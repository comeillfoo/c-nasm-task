#include <stdio.h>

static int cshl( int n, int shift ) {
  return ( n << shift ) | ( n >> ( sizeof( n ) * 8 - shift ) );
}

static void print_bin( int n ) {
  for ( size_t i = 0; i < sizeof( n ) * 8; ++i )
    printf( "%d", cshl( n, i + 1 ) & 1 );
  printf( "\n" );
}

int main( int argc, char** argv ) {
  int n = 0;
  scanf( "%d", &n ); // read the random int
  
  print_bin( n ); // print binary represenation

  return 0;
}