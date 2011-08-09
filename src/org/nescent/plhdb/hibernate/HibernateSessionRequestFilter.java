package org.nescent.plhdb.hibernate;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class HibernateSessionRequestFilter implements Filter {

	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(HibernateSessionRequestFilter.class);
		}
		return log;
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {

                Session session = HibernateSessionFactory.getSession();
                Transaction tx = null;
		try {
			log().debug("Starting a database transaction");
			tx = session.beginTransaction();

			// Call the next filter (continue request processing)
			chain.doFilter(request, response);

			// Commit if needed and cleanup
                        if (tx.isActive()) {
                            log().debug("Committing the database transaction");
                            tx.commit();
                            session.close();
			}
		} catch (Throwable ex) {
			log().error("failed to process the request!", ex);
                        if ((tx != null) && tx.isActive()) tx.rollback();
                        if (session.isOpen()) session.close();
			throw new ServletException(ex);
		}
	}

	public void init(FilterConfig filterConfig) throws ServletException {

	}

	public void destroy() {
	}

}