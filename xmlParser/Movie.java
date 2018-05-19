package xmlParser;
import java.util.*;
public class Movie{
	
	public String id;
	public String title;
	public int year;
	public String director;
	public ArrayList<String> genre;

	
	public Movie(){
	}
	
	public Movie(String title, int year, String director, ArrayList<String> genre, String id){
		this.id = id;
		this.title = title;
		this.year = year;
		this.director = director;
		this.genre = genre;

	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public String getDirector() {
		return director;
	}

	public void setDirector(String director) {
		this.director = director;
	}
	
	public ArrayList getGenre() {
		return genre;
	}

	public void setGenre(ArrayList genre) {
		this.genre = genre;
	}
	public String insertmovie() {
		
		
		return String.format("insert into movies value('%s',%s,'%d',%s) ", this.id,this.title,this.year,this.director);
		
	}
	
	public String toString() {
		
		StringBuffer sb = new StringBuffer();
		sb.append("Movie details - ");
		sb.append("Title:" + getTitle());
		sb.append(", ");
		sb.append("ID:" + getId());
		sb.append(", ");
		sb.append("Year:" + getYear());
		sb.append(", ");
		sb.append("Director:" + getDirector());
		sb.append("Genre:" + getGenre());
	
		sb.append(".");
		
		return sb.toString();
		
	}
	
	
	


}
