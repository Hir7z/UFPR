//http://br.spoj.com/problems/BINGO10/

#include<bits/stdc++.h>

#define SIZE 100
using namespace std;

int n,b,res[SIZE],v[SIZE],a,c,r;

int main(){
   while(scanf("%d %d",&n,&b) && n || b){ 
      memset(v,0,sizeof(v));
      memset(res,0,sizeof(res));
      for(int i = 0;i<b;i++){
         scanf("%d",&v[i]);
      }   
      for(int i = 0;i<b;i++){
         for(int j = i;j<b;j++){
            a = v[i];
            c = v[j];
            if(a > c){ 
               res[a-c] = 1;
            }
            else
               res[c-a] = 1;
         }
      }   
      for(int i = 1;i<=n;i++){
         if(res[i] == 0){ 
            r = 1;
            break;
         }
         else
            r = 0;
      }   
      if(r == 1)
         printf("N\n");
      else
         printf("Y\n");
   }   
}