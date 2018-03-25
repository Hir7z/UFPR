#include<bits/stdc++.h>
#include <graphviz/cgraph.h>


using namespace std;

typedef struct {Agrec_t hdr;int visitado;} mydata;
mydata *p; 

stack<Agnode_t*> pilha;
char sNome[500];
int valor = 1;

//Faz uma DFS,na recursao empilha o vértice.
void empilha(Agraph_t *g,Agnode_t *v){
    p = (mydata*) aggetrec(v, "mydata", TRUE);
	if(p->visitado == 1)  return;
	p->visitado = 1;
	
	for (Agedge_t *e = agfstout(g,v); e; e = agnxtout(g,e)){
	    Agnode_t *proxnodo = aghead(e);
	    empilha(g,proxnodo);
	}
	pilha.push(v);
}
//DFS no grafo transposto
void dfs(Agraph_t *g,Agnode_t *v,Agraph_t *h){
    p = (mydata*) aggetrec(v, "mydata", TRUE);
	if(p->visitado == 1)  return;
	p->visitado = 1;
	agsubnode(h,v,TRUE);
	for (Agedge_t *e = agfstin(g,v); e; e = agnxtin(g,e)){
		Agnode_t *proxnodo = agtail(e);
	    dfs(g,proxnodo,h);
	}
	
}
int main(void){

    Agraph_t *g = agread(stdin, NULL);
 
    for (Agnode_t *v=agfstnode(g); v; v=agnxtnode(g,v)){
        p = (mydata*) agbindrec(v,"mydata",sizeof(mydata),TRUE);
        p->visitado = 0;
    }
    
    for (Agnode_t *v=agfstnode(g); v; v=agnxtnode(g,v)){
        empilha(g,v);
    }
 	//Marcar vértices como não visitados para fazer uma segunda busca
	for (Agnode_t *v=agfstnode(g); v; v=agnxtnode(g,v)){
        p = (mydata*) agbindrec(v,"mydata",sizeof(mydata),TRUE);
        p->visitado = 0;
    }
    while(!pilha.empty()){
    	Agnode_t *v = pilha.top();
    	pilha.pop();
    	 p = (mydata*) agbindrec(v,"mydata",sizeof(mydata),TRUE);
    	 if(p->visitado ==0){
    	 	sprintf(sNome, "Cluster%d", valor);
    		Agraph_t *h = agsubg(g,sNome,TRUE);
			valor++;
    		dfs(g,v,h);
    	 }
    }
    
    agwrite(g, stdout);
    agclose(g);
    
    return 0;
}

