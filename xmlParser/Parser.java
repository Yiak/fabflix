package xmlParser;
import java.io.IOException;
import java.util.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
public class Parser {
	public HashMap<String, Stars> starm;
	public HashMap<String,Movie> moviem;
	public HashMap<String,ArrayList<String>> newmap;
	Document main;
	Document cast;
	Document star;
	public Parser() {
		starm = new HashMap<String,Stars>();
		moviem = new HashMap<String,Movie>();
		newmap = new HashMap<String, ArrayList<String>>();
	}
	public void runparser() {
		
		parseXmlFile();
		parseDocument();
	    parseActors();
	    parseCasts();
		addtotable();
		
		
		
	}
	private void parseActors() {
		Element docEle = star.getDocumentElement();
		NodeList nl = docEle.getElementsByTagName("actor");
		if (nl != null && nl.getLength() > 0) {
            for (int i = 0; i < nl.getLength(); i++) {

                //get the employee element
                Element el = (Element) nl.item(i);

                //get the Employee object
                Stars result = getStar(el);

                //add it to list
                
                
                starm.put(result.getsname(),result);
            }
        }
		
	}
	
	
	
	
	

	private void parseCasts() {
		Element docEle = cast.getDocumentElement();
		NodeList nl = docEle.getElementsByTagName("filmc");
		
		
		if (nl != null && nl.getLength() > 0) {
            for (int i = 0; i < nl.getLength(); i++) {
                Element el = (Element) nl.item(i);
                NodeList nl1 = el.getElementsByTagName("m");
                for(int j=0;j<nl1.getLength();j++)
                {
                	Element el1  = (Element) nl1.item(j);
                	
                	String key = getTextValue(el1,"f");
                	String value = getTextValue(el1,"a");
                	
                	if(newmap.containsKey(key))
                	{
                		ArrayList<String> a = newmap.get(key);
                		if(!value.equals("s a"))
                		  a.add(value);
                		newmap.put(key, a);
                	}
                	else {
                		ArrayList<String> arl = new ArrayList<String>();
                		if(!value.equals("s a")) 
                			arl.add(value);
                		newmap.put(key, arl);
                	}
                	
                }
               
            }
        }
		
	}
	
	
	
private void addtotable() {
		
        String loginUser = "mytestuser";
        String loginPasswd = "mypassword";
        String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
		
        
        try {
        	
        	Class.forName("com.mysql.jdbc.Driver").newInstance();
        	Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
        	Statement s1 = dbcon.createStatement();
        	//perform a dupication check before each batch insert
        	ResultSet rs1  = s1.executeQuery("select distinct(title),id from movies;");
        	
        	HashMap<String,String> movie_titles = new HashMap<String,String>(); //title->id
        	HashMap<String,String> star_names = new HashMap<String,String>(); //title->id
        	HashMap<String,Integer> genre_names = new HashMap<String,Integer>(); //title->id
        	
        	while(rs1.next())
        	{
        		movie_titles.put(rs1.getString(1),rs1.getString(2));
        	}
        	
        	rs1.close();
        	s1.close();
        	
        	Statement s2  = dbcon.createStatement();
        	ResultSet rs2  = s2.executeQuery("select distinct(name),id from stars;");
        	
        	
        	while(rs2.next())
        	{
        		star_names.put(rs2.getString(1),rs2.getString(2));
        	}
        	
        	rs2.close();
        	s2.close();
        	
        	 s2  = dbcon.createStatement();
        	 rs2  = s2.executeQuery("select distinct(name),id from genres;");
        	
        	
        	while(rs2.next())
        	{
        		genre_names.put(rs2.getString(1),rs2.getInt(2));
        	}
        	
        	rs2.close();
        	s2.close();
        	
        	int maxgenre = 30;
        	s2 = dbcon.createStatement();
        	rs2 = s2.executeQuery("select max(id)+1 from genres;");
        	while(rs2.next())
        		maxgenre = rs2.getInt(1);
        	
        	rs2.close();
        	s2.close();
        	
        	int s_min = 1105;
        	s2 = dbcon.createStatement();
        	rs2 = s2.executeQuery("select min(id)-1 from stars;");
        	while(rs2.next())
        		s_min = Integer.parseInt(rs2.getString(1));
        	
        	rs2.close();
        	s2.close();
        	
        	
        	System.out.println("Number of stars "+starm.size());
        	System.out.println("Number of movies "+moviem.size());
        	System.out.println("Number of casts "+newmap.size());
        	

       
        	
        	PreparedStatement preps1;
        	PreparedStatement preps2;
        	PreparedStatement preps3;
        	PreparedStatement preps4;
        	PreparedStatement preps5;
        	
        	int[] iNoRows;
        	int[] iNoRows1;
        	int[] iNoRows2;
        	int[] iNoRows3;
        	int[] iNoRows4;
        	
        	String insertm="insert into movies values(?,?,?,?)";
        	String inserts = "insert into stars values(?,?,?)";
        	String insertg = "insert into genres values(?,?)";
        	String inserta = "insert into stars_in_movies values(?,?)";
        	String addgenre = "insert into genres_in_movies values(?,?)";
        	
        
        	
        	try {
        		dbcon.setAutoCommit(false);
        		preps1=dbcon.prepareStatement(insertm);
        		preps2=dbcon.prepareStatement(inserts);
        		preps3=dbcon.prepareStatement(insertg);
        		preps4=dbcon.prepareStatement(inserta);
        		preps5=dbcon.prepareStatement(addgenre);
        		
        		
        		int count = 0;
        		Iterator it = moviem.entrySet().iterator();
        	    while (it.hasNext()) {
        	            Map.Entry pair = (Map.Entry)it.next();
        	            
        	            Movie m = ((Movie)pair.getValue());
        	            
        	            if(!movie_titles.containsKey(m.getTitle())&&m.getTitle()!=null && !m.getTitle().equals("NULL")) {
        	            	String m_id = setnewid(m.getId());
        	            	preps1.setString(1, m_id);
        	            	
        	            	String m_title = "NULL";
        	            	if(m.getTitle()!=null)
        	            		m_title = m.getTitle();
        	            	preps1.setString(2, m_title);
        	                    	            	
        	            	preps1.setInt(3, m.getYear());
        	            	
        	            	String m_director = "NULL";
        	            	if(m.getDirector()!=null)
        	            		m_director = m.getDirector();
        	            	preps1.setString(4, m_director);
        	            	preps1.addBatch();
        	            	movie_titles.put(m_title,m_id);
        	            	for(int i=0;i<m.genre.size();i++) {
        	            		
        	            		String gName = m.genre.get(i);
        	            		if(!genre_names.containsKey(gName)&&gName!=null) {
        	            			int g_id = count + maxgenre;
        	            			preps3.setInt(1, g_id);
        	            			preps3.setString(2, gName);
        	            			preps3.addBatch();
        	            			count++;
        	            			preps5.setInt(1, g_id);
        	            			preps5.setString(2,m_id);
        	            			preps5.addBatch();
        	            			genre_names.put(gName,g_id);  
        	            		}
        	            		else { 
        	            			if(gName!=null) {
        	            			preps5.setInt(1, genre_names.get(gName));
        	            			preps5.setString(2, m_id);
        	            		    preps5.addBatch();
        	            			}
        	            		}
        	            		
        	            		
        	            	}
        	            
        	            
        	            }
        	            
        	            
        	           
        	    }
        		
        	    
        	    it = starm.entrySet().iterator();
        	    int count_st=0;
        	    int testc1 = 0;
        	    while(it.hasNext())
        	    {
        	    	Map.Entry pair = (Map.Entry)it.next();
        	    	
        	    	String s_name = (String) pair.getKey();
        	    	String s_id ="";
        	    	
    	    		if(!star_names.containsKey(s_name)&&!s_name.equals("NULL")) {
    	    			
    	    			
    	    			int s_year = 0000;
    	    			try {
    	    			 s_year = ((Stars)starm.get(s_name)).getsYear();
    	    			 preps2.setInt(3, s_year);
    	    			}
    	    			catch(NullPointerException e){
    	    				
    	    				preps2.setNull(3, java.sql.Types.INTEGER);
    	    			}
    	    			s_id = setnewid(String.format("%d", (s_min - count_st)));
    	    			preps2.setString(1, s_id);
    	    			preps2.setString(2, s_name);
    	    			
    	    			preps2.addBatch();
    	    			
    	    			star_names.put(s_name,s_id);
    	    			count_st++;
    	    			testc1++;
    	    		}
        	    	
        	    	
        	    	
        	    	
        	    }
        	    
        	    
        	    
        	    
        	    //end insert star
        	    
        	    
        	    //link star and moive, only link movie and star who is exist
        	    it = newmap.entrySet().iterator();
        	    
        	   
        	    int testc2 = 0;
        	    
        	    int count_s = 0;
        	    while (it.hasNext()) {
        	    	Map.Entry pair = (Map.Entry)it.next();
        	    	ArrayList<String> sList = (ArrayList<String>) pair.getValue();
        	    	
        	    	
        	    	
        	    	String c_id = (String)pair.getKey();//raw movie id
        	    	String c_title = "NULL";
        	    	try {
        	    		c_title = moviem.get(c_id).getTitle();
        	    	}
        	    	catch(NullPointerException e)
        	    	{
        	    		System.out.println("Failed to add movie id: "+c_id);
        	    		
        	    	}
        	    	if(movie_titles.containsKey(c_title)) // we can only link star with a existing movie
    	    			c_id = movie_titles.get(c_title);
        	    	else
        	    		c_id = "NULL";
    	    		
        	    	
        	    	for(int i=0;i<sList.size();i++)
        	    	{
        	    		String s_id ="";
        	    		String s_name = sList.get(i);
        	    		
        	    		if(star_names.containsKey(s_name)&&!s_name.equals("NULL")&&!c_id.equals("NULL")) {
        	    			
        	    			s_id = star_names.get(s_name);
        	    			
        	    			if(s_id!=null) {
        	    				preps4.setString(1, s_id);
        	    				preps4.setString(2, c_id);
        	    				preps4.addBatch();
        	    				count_s++;
        	    				testc2++;
        	    			}
        	    		}
    
        	    		
        	    	}
        	    	
        	    	
        	    }
        	    
        	    
        	    iNoRows = preps1.executeBatch();
        	    iNoRows1=preps3.executeBatch();
        	    iNoRows2=preps5.executeBatch();
        	    iNoRows3=preps2.executeBatch();
        	    iNoRows4=preps4.executeBatch();
        	    
        	    
        	    
        	    dbcon.commit();
        	    
        	    
        	    
        	    
        	    System.out.println("Successfully added to database ");

        		
        	}
        	catch (SQLException e)
        	{
        		e.printStackTrace();
        		System.out.println("Some error has occurred ");
        	}
        	
        	
        	
        		
        	
        	
        	
        }
        
        catch(Exception ex)
        {
        	ex.printStackTrace();
        	
        }
		
		
	}



	private String setnewid(String id) {
		
		return "tt99" + id; //Setting a large number to will not overlap
	}

	private void parseXmlFile() {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		
		try {

            //Using factory get an instance of document builder
            DocumentBuilder db = dbf.newDocumentBuilder();
            
            //parse using builder to get DOM representation of the XML file
            main = db.parse("mains243.xml");
            star = db.parse("actors63.xml");
            cast = db.parse("casts124.xml");

        } catch (ParserConfigurationException pce) {
            pce.printStackTrace();
        } catch (SAXException se) {
            se.printStackTrace();
        } catch (IOException ioe) {
            ioe.printStackTrace();
        }
		
	}
	private void parseDocument() {
		Element docEle = main.getDocumentElement();
		NodeList nl = docEle.getElementsByTagName("film");
		if (nl != null && nl.getLength() > 0) {
            for (int i = 0; i < nl.getLength(); i++) {

                //get the employee element
                Element el = (Element) nl.item(i);

                //get the Employee object
                Movie e = getMovie(el);

                //add it to map m
                moviem.put(getTextValue(el,"fid"),e);
            }
        }
		
	}
	
	private Stars getStar(Element ele)
	{
		String name = getTextValue(ele,"stagename");
		int year = getIntValue(ele,"dob");
		
		Stars result = new Stars(name,year);
		
		return result;
	}
    private Movie getMovie(Element ele) {

        //for each <employee> element get text or int values of 
        //name ,id, age and name
        String id = getTextValue(ele, "fid");
        String title = getTextValue(ele, "t");
        int year = getIntValue(ele, "year");
        String director = "";
        ArrayList<String> genre  = new ArrayList<String>();
        
        NodeList tor = ele.getElementsByTagName("dirs");
        if(tor!=null&&tor.getLength()>0)
        {
        	Element el = (Element) tor.item(0);
        	NodeList nl1 = el.getElementsByTagName("dir");
        	if(nl1!=null&&tor.getLength()>0)
        	{
        		Element el1 = (Element)nl1.item(0);
        		director = getTextValue(el1,"dirn");
        	}
        	
        }
        
        NodeList nl2  = ele.getElementsByTagName("cats");
        if(nl2!=null&&nl2.getLength()>0)
        {
        	for(int i=0;i<nl2.getLength();i++)
        	{
        		genre.add ( getTextValue((Element)nl2.item(0),"cat") );
        	}
        	
        }

        Movie result = new Movie(title,year, director,genre,id);

        return result;
    }
    private String getTextValue(Element ele, String tagName) {
        
    	try {
    	String textVal = null;
        NodeList nl = ele.getElementsByTagName(tagName);
        if (nl != null && nl.getLength() > 0) {
            Element el = (Element) nl.item(0);
            textVal = el.getFirstChild().getNodeValue();
        }

        return textVal;
    	}
    	catch(NullPointerException e) {
    		return "NULL";
    	}
    }
    private int getIntValue(Element ele, String tagName) {
        
    	try {
        return Integer.parseInt(getTextValue(ele, tagName));
    	}catch(NumberFormatException e) {
    		return 0;
    	}
    }
    public static void main(String [] args) {
    	Parser res = new Parser();
    	res.runparser();
    }
	
	

}
