#include <stdio.h>
#include <string.h>
#include <graphviz/cgraph.h>


void dfs(Agraph_t *g,Agnode_t *v,Agnode_t *folha){
    char *atributoA,*atributoB,valorchar[500];
    int valorB,valor;
    
    //Pega rotulo da folha "sobe" atualizando caminho(rotulo +1) até a raíz original
	for (Agedge_t *e = agfstin(g,v); e; e = agnxtin(g,e)){//printf("ENTOR\n");
	    Agnode_t *proxnodo = agtail(e);
	    for (Agsym_t *atributo=agnxtattr(g,AGNODE,NULL); 
         atributo; 
         atributo=agnxtattr(g,AGNODE,atributo)){
             atributoA = agxget(folha, atributo);
                atributoB = agxget(proxnodo, atributo);
                valorB = 0;
                if (strcmp(atributoB,"") != 0){
					 valorB = 	atoi(agxget(proxnodo,atributo));
                }
			    valor =  atoi(atributoA) + valorB;
			    sprintf(valorchar, "%d", valor);
			    agxset(proxnodo, atributo, valorchar);
         }
	    dfs(g,proxnodo,folha);
	    
	}
	
}

int main(void){

    Agraph_t *g = agread(stdin, NULL);
 
    //Procura folha e "transforma" em raiz
    for (Agnode_t *v=agfstnode(g); v; v=agnxtnode(g,v)){
        if(agfstout(g, v)==NULL){//printf("entrou\n");
            dfs(g,v,v);
        }
    }
 
    agwrite(g, stdout);
    agclose(g);
    
    return 0;
}


