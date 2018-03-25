//Fibonacci em PD
//https://www.urionlinejudge.com.br/judge/pt/runs/code/4856697

#include<stdio.h>

main(){
    int a,i,j;
   long long int v[60];
   v[0] = 0;
   v[1] = 1;
   for(i=2;i<=60;i++){
       v[i] = v[i-1] + v[i - 2];
   }
    scanf("%d",&i);
    for(j = 0; j<i; j++){
        scanf("%d",&a);
        printf("Fib(%d) = %lld\n",a,v[a]);
    }
}

