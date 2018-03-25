//Exercicio de grafo bipartido
//https://www.urionlinejudge.com.br/judge/pt/problems/view/2131

#include<bits/stdc++.h>

#define SIZE 10000

using namespace std;

int pintado[105],V[105][105],a,b,m,n,teste,instacia;

int dfs(int u,int cor){
    if((pintado[u] == -1))
        pintado[u] = cor;
    for(int i = 0; i<n; i++){
        if(V[u][i] && pintado[i] == cor){
            return 0;
        }
        if(V[u][i] && pintado[i] == -1){
                dfs(i,(1 - cor));
        }
    }
    return 1;
}

int main(){
    instacia = 1;
    while(scanf("%d",&n) != EOF){
        teste = 1;
        memset(V,0,sizeof(V));
        for(int i = 0; i<n; i++)
            pintado[i] = (-1);
        scanf("%d",&m);
        for(int i=0; i<m; i++){
            scanf("%d %d",&a,&b);
            V[a-1][b-1] = 1;
            V[b-1][a-1] = 1;
        }
        for(int i=0; i<n; i++){
            if((pintado[i] == -1)){
                teste = dfs(i,1);
                 for(int j = 0; j<n; j++)
                    pintado[j] = (-1);
                if(!teste)
                    break;
            }
        }
        printf("Instancia %d\n",instacia);
        if(teste)
            printf("sim\n");
        else
            printf("nao\n");
        printf("\n");
        instacia++; 
    }
   // printf("\n");
    return 0;
}