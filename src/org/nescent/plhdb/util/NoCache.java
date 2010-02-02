package org.nescent.plhdb.util;

import javax.servlet.http.HttpServletResponse;

public class NoCache {
	public static void nocache(HttpServletResponse response)
	{
		response.addHeader("Cache-Control", "no-cache");
		response.addHeader("Cache-Control", "no-store");
		response.addHeader("Pragma", "no-cache");
		response.addHeader("Expires","1");
	}
}
