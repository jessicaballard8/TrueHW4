
const int sizeOfH = 255;
uint16_t h[sizeOfH] = {0};
uint16_t a[sizeOfH] = {0};

void saveCoefficients()
{
  if ((coeff_fp=fopen(coeff_filename,"r")) == NULL) {
  		printf("Coefficient's File Not Found\n"); return 1;
  		printf("Coefficient's File Not Found\n");
  		return 1;
  	}
  	else {
  		n=0;
  		while ((feof(coeff_fp) == 0) && (n<sizeOfH)) {
  			fscanf(coeff_fp,"%x",&a[n]);
  			fscanf(coeff_fp,"%x",&a[n]); //store values of coefficients in a[n]
  			n++;
  		}
  printf("%d coefficients read.\n",n);
}

void calculateCoefficients()
{
  //counter variables
  int counter; //for h[]
  int j; //for storeLSBPosition[]
  int storeCounter; //for storeMSBValue[] and storeLSBPostion[]
  int n; //for calculating POT

  uint16_t mask;
  int storeLSBPosition[16] = {0};
  uint16_t storeMSBValue[16] = {0};


  for (counter = 0; counter < sizeOfH; counter++)
  {
    //only look at the 16 LSB
    uint16_t LSBofCoeff = ((a[counter] && 0x0000FFFF) << 15); //keep the LSB of coeff
    uint16_t MSBofCoeff = (a[counter] && 0xFFFF0000); //keep the MSB of coeff
    mask = 0x8000; //set mask to: 1000000000000000 -> this represent 2^-1 shift
    storeCounter = 0; //storeCounter will have the # of values in the array to calculate H coefficients

    //determine the 'necessary' values of h
    for(j = 0; j < 15; j++)
    {
      if ((LSBofCoeff && mask) == mask) //if LSB of Coefficient has a 1 -> store value
      {
        storeLSBPosition[storeCounter] = (j+1); //stores the position of the '1's in the LSB
        storeMSBValue[storeCounter] = ((MSBofCoeff && mask)>>15); //stores the sign of the value associated with LSB
        storeCounter++;
      }
      else  //if LSB value = '0'
      {
        storeLSBPosition[storeCounter] = {};//then delete array element/ do not store
        storeMSBValue[storeCounter] = {};
      }
      mask = mask >> 1; //left shift so it continues through all 16 bits
    }

    //determine addition or subtraction
    for(n = 0; n < storeCounter; n++)
    {
      if(storeMSBValue[n] == 0x0001{ //if the value of MSB == 1 for where position of LSB holds a value
        h[counter] = h[counter] - 2^(-storeLSBPosition[n]);
      }
      else{
        h[counter] = h[counter] + 2^(-storeLSBPosition[n]);
      }
    printf("Value of h[%d] = %x\n", counter, &h[counter]);
    } //end of h calculation
  } //end of outside FOR loop
} //end of calculateCoefficients function
