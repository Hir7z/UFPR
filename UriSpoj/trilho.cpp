//Stack
//https://www.urionlinejudge.com.br/judge/pt/problems/view/1062

#include<bits/stdc++.h>


#define SIZE 100005
using namespace std;

int n,c,r,xunxo;
stack<int> pilha;

int main(){
    while(scanf("%d",&n) && n ){
        while(scanf("%d",&c) && c){
            pilha.push(1);
            r = 1;
            xunxo = 1;
            for(int i = 2;i<=n;i++){
                if(pilha.top() > c){
                    r = 0;
                }
                 else{
                    if(c > pilha.top())
                        pilha.push(xunxo + 1);
                    while(c != pilha.top()){
                            pilha.push(pilha.top()+1);
                    }
                    if(c > xunxo){
                        xunxo = c;
                    }
                    pilha.pop();
                    if(pilha.empty()){
                            pilha.push(xunxo + 1);
                            xunxo++;
                        }
                }
                scanf("%d",&c);
            }
            while(!pilha.empty()){
                pilha.pop();
            }
            r == 0 ? printf("No\n") : printf("Yes\n"); 
        }
        printf("\n");
    }
    
    
    return 0;
}