#include <stdio.h>

// функция циклическиго сдвига влево
// используется побитовое или двух сдвигов << - влево, и >> - вправо
static int cshl( int n, int shift ) {
  return ( n << shift ) | ( n >> ( sizeof( n ) * 8 - shift ) );
}

// функция печати бинарного представления числа
// последовательно циклически сдвигает число влево и проверяет первый бит, если 1 то печает 1, иначе 0
static void print_bin( int n ) {
  for ( size_t i = 0; i < sizeof( n ) * 8; ++i )
    printf( "%d", cshl( n, i + 1 ) & 1 );
  printf( "\n" );
}

#define BYTE_MASK (0xff) // маска одно байта, чтобы занулять старшие разряды, кроме первого байта

// функция обмена двух переменных значениями с помощью третей
static void swap( int* a, int* b ) {
  int tmp = 0;
  tmp = *a;
  *a = *b;
  *b = tmp;
}

// функция, которая выполняет задание
static int convert( int n ) {
  int b[4] = {
    ( n >>  0 ) & BYTE_MASK,
    ( n >>  8 ) & BYTE_MASK,
    ( n >> 16 ) & BYTE_MASK,
    ( n >> 24 ) & BYTE_MASK
  }; // массив отдельных байтов исходного числа

  // сортировка массива за минимальное число сравнений,
  // просто обмениваем соседние элементы массивы, если один из них больше
  if( b[ 0 ] > b[ 1 ] ) swap( &b[ 0 ], &b[ 1 ] );
  if( b[ 2 ] > b[ 3 ] ) swap( &b[ 2 ], &b[ 3 ] );
  if( b[ 0 ] > b[ 2 ] ) swap( &b[ 0 ], &b[ 2 ] );
  if( b[ 1 ] > b[ 3 ] ) swap( &b[ 1 ], &b[ 3 ] );
  if( b[ 1 ] > b[ 2 ] ) swap( &b[ 1 ], &b[ 2 ] );

  // возвращаем побитовое ИЛИ всех четырех элементов массива, сдвинутых на соответствующие разряды
  return ( b[ 3 ] << 24 ) | ( b[ 2 ] << 16 ) | ( b[ 1 ] << 8 ) | ( b[ 0 ] << 0 );
}

// главная функция
int main( int argc, char** argv ) {
  int n = 0;
  size_t k = scanf( "%d", &n ); // read the random int
  if ( k < 1 ) {
    printf( "error: could not parse input text\n" );
    return -1;
  }

  // печатаем бинарного представление исходного числа
  print_bin( n ); // print binary represenation

  // printf( "%d\n", convert(n) );

  // печатаем бинарное представление преобразованного числа
  print_bin( convert( n ) );
  return 0;
}