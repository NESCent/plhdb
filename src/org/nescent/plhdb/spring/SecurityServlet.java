/**
 * SecurityServlet: class to check the permission for each request
 */
package org.nescent.plhdb.spring;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.hibernate.HibernateSessionFactory;
import org.springframework.web.servlet.DispatcherServlet;
import java.security.AccessControlException;
import java.io.IOException;

/**
 * @author xianhua
 * 
 */
public class SecurityServlet extends DispatcherServlet {

	private static Logger log;

	private static Logger log() {
		if (log == null) {
			log = Logger.getLogger(SecurityServlet.class);
		}
		return log;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.springframework.web.servlet.DispatcherServlet#doDispatch(javax.servlet
	 * .http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	protected void doDispatch(HttpServletRequest arg0, HttpServletResponse arg1)
			throws Exception {
		super.doDispatch(arg0, arg1);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.springframework.web.servlet.DispatcherServlet#doService(javax.servlet
	 * .http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	protected void doService(HttpServletRequest request,
			HttpServletResponse response) {
		String studyid = request.getParameter("studyid");
		try {
			String uri = request.getRequestURI();
			if (uri.indexOf("login.go") > -1){
				setActiveMenu("login",request);
				super.doService(request, response);
			}else if (uri.indexOf("MOU") > -1)
                            // FIXME: needs to be config parameter!
				response.sendRedirect("http://www.nescent.org/wg/plhd/images/d/d7/Final_Internal_MOU.pdf");
			else if (uri.indexOf("Acknowledgments") > -1)
                            // FIXME: needs to be a config parameter!
				response.sendRedirect("https://docs.google.com/document/pub?id=1rjUon48QburrO-xHd_2qxiC9wMQwZf4fZQ9RdbalYtU");
			else if (uri.indexOf("register.go") > -1)
				super.doService(request, response);
			else if (uri.indexOf("cv.go") > -1)
				super.doService(request, response);
			else if (uri.indexOf("reset/password.go") > -1)
				super.doService(request, response);
			else if (uri.indexOf("change/password.go") > -1)
				super.doService(request, response);
			else if (uri.indexOf("edit.go") > -1
					&& (studyid == null || studyid.trim().equals(""))) {
				setActiveMenu("edit",request);
				super.doService(request, response);
			} else if (uri.indexOf("search/biography.go") > -1) {
				setActiveMenu("search_biography",request);
				super.doService(request, response);
			} else if (uri.indexOf("search/fertility.go") > -1) {
				setActiveMenu("search_fertility",request);
				super.doService(request, response);
			}else {

				PermissionManager manager = (PermissionManager) request
						.getSession().getAttribute("permission_manager");
				boolean isadmin = ((Boolean) request.getSession().getAttribute(
						"isadmin")).booleanValue();
				if (manager == null) {
					request.getSession().setAttribute("Message",
							"You have not logged in. Login please!");
					response.sendRedirect("/plhdb-demo/jsp/login.jsp");
				} else {
					if (uri.indexOf("view/users.go") != -1
							|| uri.indexOf("view/user.go") != -1
							|| uri.indexOf("save/user.go") != -1
							|| uri.indexOf("delete/user.go") != -1
							|| uri.indexOf("add/user.go") != -1
							|| uri.indexOf("edit/user.go") != -1) {
						setActiveMenu("users",request);
						if (isadmin) {
							super.doService(request, response);
						} else {
							throw new AccessControlException(
									"Sorry! you do not have the authority.");
						}
					} else {
						setActiveMenu("edit",request);
						String study = getStudy(request);
						String access = getAccess(request);
						if (study == null) {
							study = "all";
						}
						if (access == null) {
							access = "all";
						}
						org.nescent.plhdb.aa.Permission p = new org.nescent.plhdb.aa.Permission();
						p.setAccess(access);
						p.setStudy(study);

						if (manager.permit(p))
							super.doService(request, response);
						else
							throw new AccessControlException(
									"Sorry! you do not have the authority.");
					}
				}
			}
		} catch (HibernateException e) {
			log().error("hibernate error", e);

			request.getSession().setAttribute("Message",
					"Error: " + e.getMessage());
			try {
				response.sendRedirect("/plhdb-demo/jsp/error.jsp");
			} catch (IOException ioe) {
				log().error("failed to redirect to the error page.", ioe);
				throw new RuntimeException(
						"failed to redirect to the error page.", ioe);
			}
		} catch (Exception e) {
			log().error("something wrong happended", e);
			request.getSession().setAttribute("Message",
					"Error: " + e.getMessage());
			try {
				response.sendRedirect("/plhdb-demo/jsp/error.jsp");
			} catch (IOException ioe) {
				log().error("failed to handle the request.", ioe);
				throw new RuntimeException("failed to handle the request.", ioe);
			}

		}
	}

	private String getStudy(HttpServletRequest request) {
		return request.getParameter("studyid");

	}

	private String getAccess(HttpServletRequest request) {
		String uri = request.getRequestURI();
		if (uri.indexOf("/save/") > -1)
			return "edit";
		if (uri.indexOf("/add/") > -1)
			return "insert";
		if (uri.indexOf("/delete/") > -1)
			return "delete";
		if (uri.indexOf("/search/") > -1)
			return "search";
		if (uri.indexOf("/remove/") > -1)
			return "delete";
		if (uri.indexOf("edit.go") > -1)
			return "edit";

		return null;
	}
    
	private void setActiveMenu(String menu, HttpServletRequest request){
		request.setAttribute("active_menu",menu);
	}
}
