//Grafo BFS
// https://www.urionlinejudge.com.br/judge/pt/problems/view/2230

#include<bits/stdc++.h>


#define SIZE 100005
using namespace std;

int c,e,l,p,dist[SIZE],visit[SIZE],res[SIZE];
vector<int> adjlist[SIZE];
//set<int> res;

bool comp (int i,int j) { return (i<j); }

int main(){
    scanf("%d %d %d %d",&c,&e,&l,&p);
    int j= 1;
    //Le grafo e coloca numa lista adjacente,tipo uma array de pilha.
    while(c!=0 && e!=0 && l!=0 && p!=0){
        for (int i = 1; i <= c; i++) adjlist[i].clear();
        for(int i=0; i<e; i++){
            int a,b;
            scanf("%d %d",&a,&b);
            adjlist[a].push_back(b);
            adjlist[b].push_back(a);
        }
            memset(visit,0,sizeof visit);
            memset(dist,-1,sizeof dist);
            dist[l] = 0;
            visit[l] = 1;
            queue<int> bfsq;
            bfsq.push(l);
            int m=0;
            while(!bfsq.empty()){
                int u=bfsq.front();
                bfsq.pop();
                for(int i=0;i<adjlist[u].size();i++){
                    int v=adjlist[u][i];
                    if(!visit[v]){
                        visit[v] = 1;
                        dist[v] = dist[u] + 1;
                        if(dist[v]<=p){
                            int x = v;
                            res[m] = x;
                            m++;
                        }
                        bfsq.push(v);
                    }
                }
            }
            sort(res,res+m,comp);
            printf("Teste %d\n",j);
            for(int i=0; i<m;i++){
                printf("%d ",res[i]);
            }
    printf("\n\n");
    j++;
    scanf("%d %d %d %d",&c,&e,&l,&p);
    }
    return 0;
}