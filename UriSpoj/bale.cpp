//Implementação arovre loca BIT
//http://br.spoj.com/problems/BALE11/

#include<bits/stdc++.h>


#define SIZE 100005
using namespace std;

int soma,n,A[SIZE],tree[SIZE];

void update(int idx,int val){
    while(idx < SIZE){
        tree[idx] += val;
        idx+= (idx & -idx);
    }
}

int read(int idx){
   int soma = 0;
   while(idx > 0){
       soma+= tree[idx];
       idx -= (idx & -idx);
   }
   return soma;
}

int main(){
    scanf("%d",&n);
    soma = 0;
    memset(tree,0,sizeof(tree));
    
    for(int j = 0; j< n; j++){
        scanf("%d",&A[j]);
    }

    for(int i = n-1 ; i>= 0; i--){
        soma+=read(A[i]-1);
        update(A[i],1);
        
    }
    printf("%d\n",soma);

    return 0;
}