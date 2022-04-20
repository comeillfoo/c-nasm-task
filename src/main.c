#include <stdio.h>

static int cshl( int n, int shift ) {
  return ( n << shift ) | ( n >> ( sizeof( n ) * 8 - shift ) );
}

static void print_bin( int n ) {
  for ( size_t i = 0; i < sizeof( n ) * 8; ++i )
    printf( "%d", cshl( n, i + 1 ) & 1 );
  printf( "\n" );
}

#define BYTE_MASK (0xff)

static void swap( int* a, int* b ) {
  int tmp = 0;
  tmp = *a;
  *a = *b;
  *b = tmp;
}

static int convert( int n ) {
  int b[4] = {
    ( n >>  0 ) & BYTE_MASK,
    ( n >>  8 ) & BYTE_MASK,
    ( n >> 16 ) & BYTE_MASK,
    ( n >> 24 ) & BYTE_MASK
  };

  if( b[ 0 ] > b[ 1 ] ) swap( &b[ 0 ], &b[ 1 ] );
  if( b[ 2 ] > b[ 3 ] ) swap( &b[ 2 ], &b[ 3 ] );
  if( b[ 0 ] > b[ 2 ] ) swap( &b[ 0 ], &b[ 2 ] );
  if( b[ 1 ] > b[ 3 ] ) swap( &b[ 1 ], &b[ 3 ] );
  if( b[ 1 ] > b[ 2 ] ) swap( &b[ 1 ], &b[ 2 ] );

  return ( b[ 3 ] << 24 ) | ( b[ 2 ] << 16 ) | ( b[ 1 ] << 8 ) | ( b[ 0 ] << 0 );
}


int main( int argc, char** argv ) {
  int n = 0;
  scanf( "%d", &n ); // read the random int
  
  print_bin( n ); // print binary represenation

  // printf( "%d\n", convert(n) );

  print_bin( convert( n ) );
  return 0;
}