package xmlParser;


public class Stars {

	private String name;
	private int year;
	public Stars() {}
	public Stars(String name,int year) {
		
		this.name = name;
		this.year = year;
	}
	public String getsname() {
		
		return this.name;
	}
	public int getsYear() {
		
		return this.year;
		
	}
	
	public String insertstar() {	
		
		return String.format("INSERT INTO stars VALUES(%s,%s,%d)","",this.name,this.year );
	}
	
	
	public String toString() {
		
		return String.format("%s , %d",this.name,this.year );
		
	}
	
}
