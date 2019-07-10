#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"
#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

#define IMAGE_X 220
#define IMAGE_Y 220
#define INPUT_IMAGE_SIZE (IMAGE_X*IMAGE_Y)
#define BORDER_QT_LOST 2
#define OUTPUT_IMAGE_SIZE ((IMAGE_X-BORDER_QT_LOST)*(IMAGE_Y-BORDER_QT_LOST))

int main() {
  void *virtual_base;
  int fd;

  int data_PIO_data_i; 
  int data_PIO_write_i;
  int data_PIO_read_i; 
  int data_PIO_rstn_i; 
  int data_PIO_data_o; 
  int data_PIO_full_o; 
  int data_PIO_empty_o;

  void *h2p_lw_PIO_data_i; 
  void *h2p_lw_write_i;
  void *h2p_lw_read_i; 
  void *h2p_lw_rstn_i; 
  void *h2p_lw_data_o; 
  void *h2p_lw_full_o; 
  void *h2p_lw_empty_o;

  FILE * file,*fileout;

  /////////open memory deveice driver
  if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
    printf( "ERROR: could not open \"/dev/mem\"...\n" );
    return( 1 );
  }

  /////////////Map physical address into a virtual address
  virtual_base=mmap( NULL, HW_REGS_SPAN,(PROT_READ | PROT_WRITE),MAP_SHARED,fd, HW_REGS_BASE );
  if( virtual_base == MAP_FAILED ) {
    printf( "ERROR: mmap() 1 failed...\n" );
    close( fd );
    return( 1 );
  }

/////////Calculate virtual address of PIOs

  h2p_lw_PIO_data_i = virtual_base + ( ( unsigned long )( ALT_LWFPGASLVS_OFST + PIO_DATA_IN_BASE  ) & ( unsigned long)( HW_REGS_MASK ) );
  h2p_lw_write_i    = virtual_base + ( ( unsigned long )( ALT_LWFPGASLVS_OFST + PIO_WRITE_BASE    ) & ( unsigned long)( HW_REGS_MASK ) );
  h2p_lw_read_i     = virtual_base + ( ( unsigned long )( ALT_LWFPGASLVS_OFST + PIO_READ_BASE     ) & ( unsigned long)( HW_REGS_MASK ) );
  h2p_lw_rstn_i     = virtual_base + ( ( unsigned long )( ALT_LWFPGASLVS_OFST + PIO_RESET_BASE    ) & ( unsigned long)( HW_REGS_MASK ) );
  h2p_lw_data_o     = virtual_base + ( ( unsigned long )( ALT_LWFPGASLVS_OFST + PIO_DATA_OUT_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
  h2p_lw_full_o     = virtual_base + ( ( unsigned long )( ALT_LWFPGASLVS_OFST + PIO_FULL_BASE     ) & ( unsigned long)( HW_REGS_MASK ) );
  h2p_lw_empty_o    = virtual_base + ( ( unsigned long )( ALT_LWFPGASLVS_OFST + PIO_EMPTY_BASE    ) & ( unsigned long)( HW_REGS_MASK ) );


  /////////Using SoC

  /// atribui valor as variveis
  data_PIO_data_i  = 0x00000001; 
  data_PIO_write_i = 0x00000000;
  data_PIO_read_i  = 0x00000000; 
  data_PIO_rstn_i  = 0x00000001; 

  ///mostra os valores
  printf("dado é = %x\n",    data_PIO_data_i );
  printf("write é = %x\n",   data_PIO_write_i );
  printf("read é = %x\n",    data_PIO_read_i );
  printf("reset n é = %x\n", data_PIO_rstn_i );

  /// atribui valores as pontes
  *(uint32_t *)h2p_lw_PIO_data_i     = data_PIO_data_i;
  *(uint32_t *)h2p_lw_write_i        = data_PIO_write_i;
  *(uint32_t *)h2p_lw_read_i         = data_PIO_read_i;
  *(uint32_t *)h2p_lw_rstn_i         = data_PIO_rstn_i;


  ///reseta
  data_PIO_rstn_i            = 0x00000000;
  *(uint32_t *)h2p_lw_rstn_i = data_PIO_rstn_i;
  data_PIO_rstn_i            = 0x00000001; 
  *(uint32_t *)h2p_lw_rstn_i = data_PIO_rstn_i;
  
  file = fopen("img.dat","r");
  char nome [10];

  int cont = 0;
  printf("escrevendo na fila\n");
  
  while (!feof(file) && cont < INPUT_IMAGE_SIZE){
  	/// Lê uma linha (inclusive com o '\n')
    fgets(nome, 10, file);
    data_PIO_data_i = strtol(nome, NULL, 10);
    
    *(uint32_t *)h2p_lw_PIO_data_i     = data_PIO_data_i;
    *(uint32_t *)h2p_lw_write_i        = 0x00000001;
    *(uint32_t *)h2p_lw_write_i        = 0x00000000;      
    data_PIO_full_o                    = *(uint32_t *) h2p_lw_full_o;
    cont++;
  }
  fclose(file);
  
  printf("foram escritos %d, ultimo inserido %d, e o barramento em %d \n", cont, *(uint32_t *)h2p_lw_PIO_data_i, *(uint32_t *) h2p_lw_full_o );

  fileout = fopen("out.dat", "w");  // Cria um arquivo texto para gravação
  if (fileout == NULL) {
    printf("Problemas na CRIACAO do arquivo\n");
    return 0;
  }


  //printf("Espera execução\n");
  
  //data_PIO_full_o = 0x0;
  //while (data_PIO_full_o == 0x0  ){
  //  // espera terminar
  //  data_PIO_full_o = *(uint32_t *) h2p_lw_full_o;
  //}
  
  printf("retirando da fila \n");
  
  cont = 0;
  char buffer[12] = {0};
  while (cont < OUTPUT_IMAGE_SIZE) {
    //printf("%d\n", cont);
    // espera ter resultado disponível
    do {
      data_PIO_empty_o = *(uint32_t *) h2p_lw_empty_o;
    } while(data_PIO_empty_o == 0x1);
    // ativa sinal de leitura
    *(uint32_t *)h2p_lw_read_i = 0x1;
    *(uint32_t *)h2p_lw_read_i = 0x0;
    // le o dado
    data_PIO_data_o = *(uint32_t *) h2p_lw_data_o;
    // converte para string e salva no arquivo
    sprintf(buffer, "%d\n", data_PIO_data_o);
    fputs(buffer, fileout);
    cont++;
  }

  fclose(fileout);

  printf("Fim de execução  \n");

  //Close memory device driver
  if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) { // clean up our memory mapping and exit
    printf( "ERROR: munmap() 1 failed...\n" );
    close( fd );
    return( 1 );
  }
  close( fd);
  return( 0 );
}
