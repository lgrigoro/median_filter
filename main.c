#include <stdio.h>
#include <stdlib.h>

void median(unsigned char *input, unsigned char *output);

int main(int argc, char * argv[])
{
    long fileLength;
    FILE *outputImage, *inputImage;
    unsigned char *inputArray, *outputArray;

    if (argc != 3)
    {
        printf ("Niewlasciwa liczba argumentow.\n");
    }
    else
    {

        if ((inputImage = fopen(argv[1], "r")) == NULL)
        {
            printf ("Nie mogę otworzyć pliku %s \n", argv[1]);
        }
        else
        {
            outputImage = fopen(argv[2], "a");
            fseek(inputImage, 0, SEEK_END);
            fileLength = ftell(inputImage);
            rewind(inputImage);
            inputArray = (unsigned char *)malloc((fileLength+1)*sizeof(unsigned char));
            outputArray = (unsigned char *)malloc((fileLength+1)*sizeof(unsigned char));
            fread(inputArray, fileLength, 1, inputImage);

            median(inputArray, outputArray);
	
            fwrite(outputArray, fileLength+1, 1, outputImage);
            fclose(outputImage);
            fclose(inputImage);
        }
    }
	return 0;
}

