#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#define high_threshold 48
#define low_threshold 12
#define MARKER_R 0
#define MARKER_G 200
#define MARKER_B 0
#define X_POS 50
#define Y_POS 100
#define WIDTH 40
#define HEIGHT 40
#define IMAGE_HEIGHT 720
#define IMAGE_WIDTH 720


struct pixel {
   unsigned char b;
   unsigned char g;
   unsigned char r;
};

// Read BMP file and extract the pixel values (store in data) and header (store in header)
// data is data[0] = BLUE, data[1] = GREEN, data[2] = RED, etc...
int read_bmp(FILE *f, unsigned char* header, int *height, int *width, struct pixel* data) 
{
	printf("reading file...\n");
	// read the first 54 bytes into the header
   if (fread(header, sizeof(unsigned char), 54, f) != 54)
   {
		printf("Error reading BMP header\n");
		return -1;
   }   

   // get height and width of image
   int w = (int)(header[19] << 8) | header[18];
   int h = (int)(header[23] << 8) | header[22];

   // Read in the image
   int size = w * h;
   if (fread(data, sizeof(struct pixel), size, f) != size){
		printf("Error reading BMP image\n");
		return -1;
   }   

   *width = w;
   *height = h;
   return 0;
}

// Write the grayscale image to disk.
void write_markered_bmp(const char *filename, unsigned char* header, struct pixel* source) {
   FILE* file = fopen(filename, "wb");
   
   int width = (int)(header[19] << 8) | header[18];
   int height = (int)(header[23] << 8) | header[22];
   int size = width * height;
   struct pixel * data_temp = (struct pixel *)malloc(size*sizeof(struct pixel)); 
   
   // write the 54-byte header
   fwrite(header, sizeof(unsigned char), 54, file); 
   int y, x;
   
   // the r field of the pixel has the grayscale value. copy to g and b.
   for (y = 0; y < height; y++) {
      for (x = 0; x < width; x++) {
         (*(data_temp + y*width + x)).b = (*(source + y*width + x)).b;
         (*(data_temp + y*width + x)).g = (*(source + y*width + x)).g;
         (*(data_temp + y*width + x)).r = (*(source + y*width + x)).r;

         if(y > Y_POS - HEIGHT/2 && y <= Y_POS + HEIGHT/2){
            if(x > X_POS - WIDTH/2 && x <= X_POS + WIDTH/2){
               (*(data_temp + y*width + x)).b = MARKER_R;
               (*(data_temp + y*width + x)).g = MARKER_G;
               (*(data_temp + y*width + x)).r = MARKER_B;
            }
         }
      }
   }
   
   fwrite(data_temp, sizeof(struct pixel), size, file); 
   
   free(data_temp);
   fclose(file);
}



int main(int argc, char *argv[]) {
   int width = 0;
   int height = 0;
   
	struct pixel *rgb_data = (struct pixel *)malloc(IMAGE_HEIGHT*IMAGE_WIDTH*sizeof(struct pixel));
   unsigned char *marked_data = (unsigned char *)malloc(IMAGE_HEIGHT*IMAGE_WIDTH*sizeof(struct pixel));
	unsigned char header[64];
	// Check inputs

	if (argc < 2) {
		printf("Usage: marker <BMP filename>\n");
		return 0;
	}

	FILE * f = fopen(argv[1],"rb");
	if ( f == NULL ) return 0;

	// read the bitmap
	read_bmp(f, header, &height, &width, rgb_data);
   printf("read");
   write_markered_bmp("marked.bmp", header, rgb_data);
   
	return 0;
}


