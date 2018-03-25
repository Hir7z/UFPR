package trabTap;

import java.util.Observable;
import java.util.ArrayList;

public class LinhaTempo extends Observable{
	ArrayList<Post> posts = new ArrayList<Post>();
	int opcao;
	
	//Funcao para publicar Post,e avisa seus observadores que há atualização.
	//Parâmetro emissor é o autor da alteraçao,ou seja o criador do pensamento,like/dislike
	//ou pensamento.
	//Parametro opcao indica o tipo do post.
	void publicarPost(Post post,Usuario emissor,int opcao){
		printaOpcao(opcao, emissor);
		printaPost(post);	
		setChanged();
		notifyObservers(post);
	}
	//Funcao que republica o post na linha do tempo dos Observadores.
	void republica(Post post,Usuario receptor){
		printaPost(post, receptor);
	}
	//Funcao para criacao de um pensamento
	//Emissor é o criador do pensamento.
	void pensamento(String texto,Usuario emissor){
			Post post = new Post(texto,emissor);
			emissor.linhaTempo.posts.add(post);
			publicarPost(post,emissor,1);
	}
	//Funcoes para criacao de likes/dislikes.
	//Emissor é quem deu o like/dislike.
	//Post é o post que está sendo alterado.
	void likes(Post post,Usuario emissor){
			post.setLike(post.getLike() + 1);
			post.getUsuario().linhaTempo.publicarPost(post,emissor,2);
	}
	void dislike(Post post,Usuario emissor){
			post.setDislike(post.getDislike() + 1);
			post.getUsuario().linhaTempo.publicarPost(post,emissor,3);
	}
	//Funcoes para criacao de um comentario.
	//Emissor é quem deu o like/dislike.
	//Post é o post que está sendo comentado.
	void comentar(String texto,Post post,Usuario emissor){
		Comentario comentario = new Comentario(texto,emissor.getNome());
		post.comentarios.add(comentario);
		post.getUsuario().linhaTempo.publicarPost(post,emissor,4);
	}
	
	//Funcao que printa na linha do tempo do receptor quem está alterado e o tipo da alteraçao.
	void printaOpcao(int opcao,Usuario emissor){
		if(opcao == 1){
			System.out.println(emissor.getNome() + " postou um pensamento");
			System.out.println();
		}
		else if(opcao == 2){
			System.out.println(emissor.getNome() + " deu um like em seu post");
			System.out.println();
		}
		else if(opcao == 3){
			System.out.println(emissor.getNome() + " deu um dislike em seu post");
			System.out.println();
		}
		else if(opcao == 4){
			System.out.println(emissor.getNome() + " comentou seu post");
			System.out.println();
		}
	}
	//Funca para printar na tela o Post.
	void printaPost(Post post){
		System.out.println("Linha do Tempo de "+ post.getAutor());
		System.out.println("Autor " + post.getAutor());
		System.out.println(post.getPostagem());
		System.out.println("Likes "+ post.getLike() );
		System.out.println("Dislikes "+ post.getDislike());
		System.out.println();
		printaComentarios(post);
	}
	
	//@Override
	//Funcao printaPost alterado para enviar post aos Observadores,
	//passando como parâmetro o usuario que recebe a atualizaçao de novo post.
	void printaPost(Post post,Usuario receptor){
		System.out.println("Linha do Tempo de "+ receptor.getNome());
		System.out.println("Autor " + post.getAutor());
		System.out.println(post.getPostagem());
		System.out.println("Likes "+ post.getLike() );
		System.out.println("Dislikes "+ post.getDislike());
		System.out.println();
		printaComentarios(post);
	}
	
	//Funcao que printa os comentarios do post.
	void printaComentarios(Post post){
		int i;
		for(i = 0;i < post.comentarios.size();i++){
			System.out.println("Comentario");
			System.out.println("Autor "+ post.comentarios.get(i).getAutor());
			System.out.println(post.comentarios.get(i).getTexto());
			System.out.println();
		}
	}
}


class Post{
	private Usuario usuario;
	private String autor;
	private String postagem;
	private int like;
	private int dislike;
	protected ArrayList<Comentario>comentarios = new ArrayList<Comentario>();
	
	public Post(String texto,Usuario pessoa){
		setLike(0);;
		setDislike(0);;
		setAutor(pessoa.getNome()); 
		setPostagem(texto);
		setUsuario(pessoa);
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public String getAutor() {
		return autor;
	}

	public void setAutor(String autor) {
		this.autor = autor;
	}

	public String getPostagem() {
		return postagem;
	}

	public void setPostagem(String postagem) {
		this.postagem = postagem;
	}

	public int getLike() {
		return like;
	}

	public void setLike(int like) {
		this.like = like;
	}

	public int getDislike() {
		return dislike;
	}

	public void setDislike(int dislike) {
		this.dislike = dislike;
	}

	public ArrayList<Comentario> getComentarios() {
		return comentarios;
	}

	public void setComentarios(ArrayList<Comentario> comentarios) {
		this.comentarios = comentarios;
	}
}

class Comentario{
	private String texto;
	private String autor;
	
	Comentario(String texto,String autor){
		this.texto = texto;
		this.autor = autor;
	}

	public String getTexto() {
		return texto;
	}

	public void setTexto(String texto) {
		this.texto = texto;
	}

	public String getAutor() {
		return autor;
	}

	public void setAutor(String autor) {
		this.autor = autor;
	}
}