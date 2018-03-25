package trabTap;

import java.util.Observer;
import java.util.Observable;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;


public abstract class Usuario  implements Observer{
	private String nome;
	private String login;
	private Date dataCriacao;
    protected LinhaTempo linhaTempo;
    
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getLogin() {
		return login;
	}
	public void setLogin(String login) {
		this.login = login;
	}
	public Date getDataCriacao() {
		return dataCriacao;
	}
	public void setDataCriacao() {
		Date data = new Date();
		this.dataCriacao = data;
	}
	public void printaData(Date data){
		SimpleDateFormat sdf= new SimpleDateFormat("dd/MM/yyyy");
		System.out.println(sdf.format(data));
	}
}

class Pessoa extends Usuario{
	protected ArrayList<Pessoa> amigos = new ArrayList<Pessoa>();
	protected ArrayList<Grupo> grupos = new ArrayList<Grupo>();
	protected ArrayList<Relacao> relacoes = new ArrayList<Relacao>();
	
	
	Pessoa(String nome,String login){
		setNome(nome);
		setLogin(login);
		setDataCriacao();
		linhaTempo = new LinhaTempo();
		System.out.println("Novo usuario " + nome);
		System.out.println();
	}
	
	void addAmigo(Pessoa p,String tipoRelacao,int afinidade){
		Relacao novaRelacao = new Relacao(tipoRelacao,afinidade);
		Relacao novaRelacao2 = new Relacao(tipoRelacao,afinidade);
		relacoes.add(novaRelacao);
		p.relacoes.add(novaRelacao2);
		amigos.add(p);
		linhaTempo.addObserver(p);
		p.amigos.add(this);
		p.linhaTempo.addObserver(this);
		System.out.println(this.getNome() + " e " + p.getNome() + " tornaram-se amigos"); 
		System.out.println();
	}
	void removeAmigo(Pessoa p){
		int i;
		i = amigos.indexOf(p);
		relacoes.get(i).setDataFim();
		relacoes.get(i).setAmigo(0);
		linhaTempo.deleteObserver(p);
		i = p.amigos.indexOf(this);
		p.relacoes.get(i).setDataFim();
		p.relacoes.get(i).setAmigo(0);
		p.linhaTempo.deleteObserver(this);
		System.out.print(this.getNome() + " e " + p.getNome() + " nao sao mais amigos "); 
		p.relacoes.get(i).printaData(p.relacoes.get(i).getDataFim());
		System.out.println();
	}
	void addGrupo(Grupo g){
		g.addPessoa(this);
	}
	void removeGrupo(Grupo g){
		g.removePessoa(this);
	}
	//@Override
	public void update(Observable linhaTempo,Object arg){
		Post p = (Post)arg;
		this.linhaTempo.republica(p,this);

	}
}

class Grupo extends Usuario{
	protected ArrayList<Pessoa>participantes = new ArrayList<Pessoa>();
	Grupo(String nome,String login){
		setNome(nome);
		setLogin(login);
		setDataCriacao();
		linhaTempo = new LinhaTempo();
		System.out.println("Novo grupo " + nome);
		System.out.println();
	}
	void addPessoa(Pessoa p){
		participantes.add(p);
		linhaTempo.addObserver(p);
		p.grupos.add(this);
		System.out.println(p.getNome() + " foi adicionado ao grupo "+ getNome());
		System.out.println();
	}
	void removePessoa(Pessoa p){
		linhaTempo.deleteObserver(p);
		participantes.remove(p);
		p.grupos.remove(this);
		System.out.println(p.getNome() + " saiu do grupo "+ getNome());
		System.out.println();
	}
	
	//@Override
		public void update(Observable linhaTempo,Object arg){
			Post p = (Post)arg;
			this.linhaTempo.republica(p,this);
		}
}

class Relacao{
	private String tipoRelacao;
	private Date dataInit;
	private Date dataFim;
	private int afinidade;
	private int amigo; //Flag para saber se pessoas ainda são amigas 1-TRUE,0-FALSE
	
	Relacao(String tipoRelacao,int afinidade){
		setTipoRelacao(tipoRelacao);
		setAfinidade(afinidade);
		setAmigo(1);
		setDataInit();
	}
	
	
	public String getTipoRelacao() {
		return tipoRelacao;
	}
	public void setTipoRelacao(String tipoRelacao) {
		this.tipoRelacao = tipoRelacao;
	}
	public Date getDataInit() {
		return dataInit;
	}
	public void setDataInit() {
		Date data = new Date ();
		this.dataInit = data;
	}
	public Date getDataFim() {
		return dataFim;
	}
	public void setDataFim() {
		Date data = new Date ();
		this.dataFim = data;
	}
	public int getAfinidade() {
		return afinidade;
	}
	public void setAfinidade(int afinidade) {
		this.afinidade = afinidade;
	}
	public void setAmigo(int amigo){
		this.amigo = amigo;
	}
	public int getAmigo(){
		return amigo;
	}
	public void printaData(Date data){
		SimpleDateFormat sdf= new SimpleDateFormat("dd/MM/yyyy");
		System.out.println(sdf.format(data));
	}
}
