
package app.quickstart.dm;
import aa.core.CreateActorException;

import aa.core.Actor;
import aa.core.ActorName;
import aa.core.CommunicationException;
import aa.tool.ActorTuple;
import java.util.*;

/**
 *  A buyer actor.
 * 
 *  <p>
 *  <b>History:</b>
 *  <ul>
 * 	<li> March 1, 2004 - version 0.0.4
 * 	<ul>
 * 	    <li> change the name of methods.
 * 	</ul>
 * 	<li> February 28, 2004 - version 0.0.3
 * 	<ul>
 * 	    <li> do minor modification.
 * 	</ul>
 * 	<li> February 19, 2004 - version 0.0.2
 * 	<ul>
 * 	    <li> do minor modification.
 * 	</ul>
 *      <li> March 22, 2003 - version 0.0.1
 *      <ul>
 *          <li> create this file.
 *      </ul>
 *  </ul>
 * 
 *  @author Myeong-Wuk Jang
 *  @version $Date: 2008/01/01 00:23:30 $ $Revision: 1.1 $
 */
class Tuple implements Comparable<Tuple> {
	    int fees;
	    int space;
	    String isp;
	    public Tuple(int fees, int space,String isp) {
	        this.fees = fees;
	        this.space = space;
                this.isp=isp;
	    }
	    
	    @Override
	    public int compareTo(Tuple other) {
	        if (other == null) return 1;
	        double ratio = (double)space / fees;
	        double otherRatio = (double)other.space / other.fees;
	        return Double.compare(otherRatio, ratio);
	    }
	    
	}
public class VNode extends Actor
{
    // ========== Object Variables ========== //
    
    private ActorName m_anDM;		//  reference to Directory Manager
    private int thMsg;
    List<Tuple> items;
    int sp;
    int count=1;
    // ========== Object Methods ========== //

    /**
     *  Creates this actor.
     */
    public VNode(String num)
    {
    	m_anDM = getDefaultDirectoryManager();
	thMsg=1000;
        items = new ArrayList<>();
	int n=Integer.parseInt(num);
	for(int i=1;i<=n;i++)
	{
		try {
    	   		 create("app.quickstart.dm.Isp","isp"+i);
    		} catch (CreateActorException e) {
    	   		 System.out.println("> Hello.Hello: " + e); 
    		}
	}
    }


    /**
     *  Checks the price of an item whose type is selected.
     * 
     *  @param p_strItem an item type selected.
     */
    public void search(String p_strItem)
    {   	
    	ActorTuple atTemplate = new ActorTuple(null, "isp", p_strItem);

    	try {
    	    ActorName anSeller = (ActorName) call(m_anDM, "search", atTemplate);
    	    send(anSeller, "checkPrice", getActorName());
    	} catch (CommunicationException e) {
    	    System.err.println("> Buyer.check: " + e);
    	}
    }
   
   
    /**
     *  Checks the price of any item.
     */
    public void search()
    {
    	search(null);
    }
    
    
    /**
     *  Checks prices of items whose type is selected.
     * 
     *  @param p_strItem an item type selected.
     */
    public void searchAll(String p_strItem)
    {
    	ActorTuple atTemplate = new ActorTuple(null, "isp", p_strItem);

    	try {
    	    ActorName[] anSeller = (ActorName[]) call(m_anDM, "searchAll", atTemplate);
    	    
    	    for (int i=0; i<anSeller.length; i++) {
    	        send(anSeller[i], "checkPrice", getActorName());
    	    }
    	} catch (CommunicationException e) {
    	    System.err.println("> Node.check: " + e);
    	}
    }
     
     
    /**
     *  Checks prices of all items.
     */
    public void searchAll()
    {
    	searchAll(null);
    }
    
    
    /**
     *  Requests the price of an item whose type is selected.
     * 
     *  @param p_strItem an item type selected.
     */
    public void deliver(String p_strItem)
    {
    	ActorTuple atTemplate = new ActorTuple(null, "isp", p_strItem);

	send(m_anDM, "deliver", atTemplate, "checkPrice", getActorName());    	
    }
    

    /**
     *  Requests the price of any item.
     */
    public void deliver()
    {
    	deliver(null);
    }
    
    
    /**
     *  Requests prices of items whose type is selected.
     * 
     *  @param p_strItem an item type selected.
     */
    public void deliverAll(String p_strItem)
    {
    	ActorTuple atTemplate = new ActorTuple(null, "isp", p_strItem);

	send(m_anDM, "deliverAll", atTemplate, "checkPrice", getActorName());    	
    }
    

    /**
     *  Requests prices of all items.
     */
    public void deliverAll()
    {
    	deliverAll(null);
    }
    
      
    /**
     *  Prints the price of a product.
     *  <br>
     *  This method is called by a seller actor.
     * 
     *  @param p_anActor the name of an actor that activate this method.
     *  @param p_strItem the name of a product item.
     *  @param p_intPrice the price of the item.
     */
    public void fractional_k(int w)
    {
		int n=items.size();
		System.out.println("-----------------round "+count+" ----------------");
		for(int i=0;i<n;i++)
		{
                        Tuple item = items.get(i);
			System.out.println(item.isp+"     "+item.fees+"     "+item.space+"\n");
		}	
          // sort items desc according to value weight ratio
	        Collections.sort(items);
	        // put in the sack as long as we can
	        int currentW = 0;
	        double currentV = 0;
	        int index = 0;
		
		System.out.println("---------------- selected isps ----------------");
	        while (currentW < w && index < n) {
	            int remaining = w - currentW;
	            Tuple item = items.get(index);
	            // if it doesn't fit, put fractional and return
	            if (remaining < item.fees) {
	                currentW += item.fees;
	                currentV += (double)remaining/item.fees * item.space;
	                System.out.println("adding fraction for " +item.isp+"    "+ (double)remaining/item.space * item.space);
	                break;
	            }
	            // otherwise put entire item
	            currentW += item.fees;
	            currentV += item.space;
	            //System.out.println("adding " + currentV);
                    System.out.println(item.isp+"     "+item.fees+"    "+item.space+"\n");
	            index++;
	        }
                for(int i=index;i<n;i++)
                {
			Tuple item = items.get(i);
			item.fees-=2;
		}
	        System.out.printf("Total space allocated: %.2f\n", currentV);
	count++;
    }

	public Integer getSp(Integer cp)
	{
		int sp;
		double Wi=Math.random();
		sp=(int)((10+(cp*Wi))/Wi);
		return sp;
	}
	

    public void price(ActorName p_anActor, String p_strItem, Integer p_intPrice,Integer p_space)
    {
    	System.out.println("> Contributing Isp [" + p_anActor + "]  " + p_strItem + 
			   " offer " +p_space + " costing " +  p_intPrice); 
	items.add(new Tuple(getSp(p_intPrice),p_space,p_strItem));
    }

public void transfer(String budget)
{
	/*int n=Integer.parseInt(numMsg);
	if(n<thMsg)
	{
		System.out.println("Since number of requests are below threshhold,so the request is not malicious..");
	}
	else
	{
	System.out.println("Since number of requests are above threshold,so the request is malicious..");
	searchAll(null);	
	}*/
	int n=Integer.parseInt(budget);
	fractional_k(n);
       

}
     
	public void dlvr()
	{
		/*System.out.println("seleceted-"+intPrice+"----"+strItem);
		deliver(strItem);*/
                fractional_k(50);
	}
		
}
