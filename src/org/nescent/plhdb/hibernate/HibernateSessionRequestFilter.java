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
import org.hibernate.StaleObjectStateException;
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

		Transaction tr = null;
		try {
			log().debug("Starting a database transaction");
			Session sess = HibernateSessionFactory.getSession();
			tr = sess.beginTransaction();

			// Call the next filter (continue request processing)
			chain.doFilter(request, response);

			// Commit and cleanup
			if (tr != null) {
				log().debug("Committing the database transaction");
				sess.flush();
				tr.commit();
			}
		} catch (StaleObjectStateException staleEx) {
			log()
					.error(
							"This interceptor does not implement optimistic concurrency control!");
			log()
					.error(
							"Your application will not work until you add compensation actions!");
			throw staleEx;
		} catch (Throwable ex) {
			log().error("failed to process the request!", ex);
			throw new ServletException(ex);
		} finally {

			if (tr != null && !tr.wasCommitted()) {
				log()
						.debug(
								"Trying to rollback database transaction after exception");
				tr.rollback();
			}
			HibernateSessionFactory.getSession().close();
		}
	}

	public void init(FilterConfig filterConfig) throws ServletException {

	}

	public void destroy() {
	}

}