
package app.quickstart.dm;

import java.util.Random;

import aa.core.Actor;
import aa.core.ActorName;
import aa.tool.ActorTuple;

/**
 *  A seller actor.
 * 
 *  <p>
 *  <b>History:</b>
 *  <ul>
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

public class Isp extends Actor
{
    // ========== Object Variables ========== //
    
    private int m_iPrice;		//  cp price of a product
    
    private String m_strModel;		//  model name of a computer.
    
	private int space;
    // ========== Object Methods ========== //

    /**
     *  Creates this actor.
     * 
     *  @param p_strModel the model name of a computer.
     */
    public Isp(String p_strModel)
    {
    	m_strModel = p_strModel;
	Random r=new Random();
    	m_iPrice = r.nextInt(20)+80;
    	space=r.nextInt(5)+5;
    	ActorName anDM = getDefaultDirectoryManager();
    	
    	ActorTuple tuple = new ActorTuple(getActorName(), "isp", m_strModel);
    	send(anDM, "register", tuple);
    }
    public void checkPrice()
    {
    	System.out.println("My current price is " + m_iPrice);
    }
    
    
    /**
     *  Sends the current price of this product.
     * 
     *  @param p_anSender the name of an actor that requested this service.
     */
    public void checkPrice(ActorName p_anSender)
    {
    	send(p_anSender, "price", getActorName(), m_strModel, new Integer(m_iPrice),new Integer(space));
    }
}
