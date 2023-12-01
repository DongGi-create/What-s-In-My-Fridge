package Phase3Package;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class URIConvert {
	public static String encodeURIComponent(String s)
	  {
	    String result = null;
	 
	    try
	    {
	      result = URLEncoder.encode(s, "UTF-8")
	                         .replaceAll("\\+", "%20")
	                         .replaceAll("\\%21", "!")
	                         .replaceAll("\\%27", "'")
	                         .replaceAll("\\%28", "(")
	                         .replaceAll("\\%29", ")")
	                         .replaceAll("\\%7E", "~");
	    }
	 
	    // This exception should never occur.
	    catch (UnsupportedEncodingException e)
	    {
	      result = s;
	    }
	 
	    return result;
	  }
}
