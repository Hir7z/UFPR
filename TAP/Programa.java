package trabTap;


public class Programa {
	public static void main(String args[]){
	Pessoa p1 = new Pessoa("Diego","hirt");
	Pessoa p2 = new Pessoa("Rafael","rafa");
	Pessoa p3 = new Pessoa("Sofia","sopa");
	Grupo g1 = new Grupo("Rock","g1");
	Grupo g2 = new Grupo("Futebol","g2");
	p1.addAmigo(p2,"Amigo",3);
	p1.addAmigo(p3,"Em Relacionamento",5);
	p1.addGrupo(g1);
	p2.addAmigo(p3,"Amigo",2);
	p2.addGrupo(g1);
	p2.addGrupo(g2);
	p3.relacoes.get(p3.amigos.indexOf(p1)).setTipoRelacao("Parente");
	p3.relacoes.get(p3.amigos.indexOf(p2)).setTipoRelacao("Conhecido");
	p1.linhaTempo.pensamento("Semestre está acabando !",p1);
	p2.linhaTempo.comentar("Finalmente",p1.linhaTempo.posts.get(0),p2);
	p2.linhaTempo.likes(p1.linhaTempo.posts.get(0),p2);
	p2.linhaTempo.pensamento("Sem criatividade",p2);
	g1.linhaTempo.pensamento("Isso chegou para todos ?",g1);
	p2.linhaTempo.dislike(g1.linhaTempo.posts.get(0),p2);
	p2.removeGrupo(p2.grupos.get(p2.grupos.indexOf(g1)));
	}
}
