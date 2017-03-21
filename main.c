#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdbool.h>

#ifdef _median
extern "C" {
#endif
int median(char* input, char* output);
#ifdef	_median
}
#endif

const int SCREEN_WIDTH = 500;
const int SCREEN_HEIGHT = 575;

void close();
bool init();
bool loadMedia(char *text);

SDL_Window* gWindow = NULL;
SDL_Surface* gScreenSurface = NULL;
SDL_Surface* gHelloWorld = NULL;

int main(void)
{
	int wynik;
	char* read, *write;
	read = (char*)malloc(20*sizeof(char));
	write = (char*)malloc(20*sizeof(char));
	printf("Podaj nazwe pliku do wczytania\n");
	scanf("%s", read);
	printf("Podaj nazwe pliku do zapisania\n");
	scanf("%s", write);
	/*printf("Podaj rozmiar okienka\n");
	scanf("%d", &windows);*/

	wynik = median(read, write);
	printf("Wypisano %d\n", wynik);
	

	if(!init())
	{
		printf("Failed to initialize!\n");
	}
	else
	{
		if(!loadMedia(write))
		{
			printf("Failed to load media!\n");
		}
		else
		{
			bool quit = false;
		
	
			while(!quit)
			{
				SDL_Event e;
				while(SDL_PollEvent(&e) && (quit  == false)){
					if(e.type == SDL_QUIT){
						quit = true;
					}
				}
				
				SDL_BlitSurface(gHelloWorld, NULL, gScreenSurface, NULL);

				SDL_UpdateWindowSurface(gWindow);
					
			}
		}
	}

	close();	
	
	return 0;
}

bool init()
{
	bool success = true;
	if(SDL_Init(SDL_INIT_VIDEO)<0)
	{
		printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
		success = false;
	}
	else
	{
		gWindow = SDL_CreateWindow("SDL Tutorial", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN);
		if(gWindow == NULL)
		{
			printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
			success = false;
		}
		else
		{
			gScreenSurface = SDL_GetWindowSurface(gWindow);
		}
	}

	return success;
}

bool loadMedia(char *text)
{
	bool success = true;
	gHelloWorld = SDL_LoadBMP(text);
	if( gHelloWorld == NULL)
	{	
		printf("Unable to load image %s! SDL Error: %s\n", ".bmp", SDL_GetError());
		success = false;
	}
	
	return success;
}

void close()
{
	SDL_FreeSurface(gHelloWorld);
	gHelloWorld = NULL;

	SDL_DestroyWindow(gWindow);
	gWindow = NULL;

	SDL_Quit();
}
