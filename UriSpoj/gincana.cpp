//Grafo DFS
//http://br.spoj.com/problems/GINCAN11/

#include<bits/stdc++.h>

#define SIZE 10000

using namespace std;

int N,M,A,B,times,V[SIZE][SIZE],visited[SIZE];

void dfs(int u){
    visited[u] = 1;
    for(int i = 0; i< N; i++){
        if(!visited[i] && V[u][i] == 1){
            dfs(i);
        }
    }
}

int main(){
        times =0;
        memset(V,0,sizeof(V));
        scanf("%d %d",&N,&M);
        for(int i = 0; i < M;i++){
            scanf("%d %d",&A,&B);
            V[A-1][B-1] = 1;
            V[B-1][A-1] = 1;
        }
        for(int i =0; i<N;i++){
            if(!visited[i]){
                dfs(i);
                times++;
            }
        }
        printf("%d\n",times);
    return 0;
}