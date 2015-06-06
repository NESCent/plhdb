/**
 * SecurityServlet: class to check the permission for each request
 */
package org.nescent.plhdb.spring;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.AccessControlException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.nescent.plhdb.aa.PermissionManager;
import org.nescent.plhdb.util.DownloadFile;
import org.nescent.plhdb.util.PlhdbConfiguration;
import org.springframework.beans.BeansException;
import org.springframework.web.servlet.DispatcherServlet;

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
	
	PlhdbConfiguration plhdbConfig;
	@Override
	protected void initFrameworkServlet() {
		try {
			super.initFrameworkServlet();
		} catch (ServletException se) {
			log().error("failed to initialize the servlet framework.", se);
			throw new RuntimeException(
					"failed to initialize the servlet framework.", se);
		} catch (BeansException be) {
			log().error("failed to initialize the servlet framework.", be);
			throw new RuntimeException(
					"failed to initialize the servlet framework.", be);
		}

		plhdbConfig = (PlhdbConfiguration) this.getServletContext().getAttribute(
				"plhdb_config");

		String configFile = "config/plhdb.conf";
		if (plhdbConfig == null) {
			plhdbConfig = new PlhdbConfiguration();
			String file = getServletContext().getRealPath(configFile);
			FileInputStream in = null;
			try {
				in = new FileInputStream(new File(file));
				plhdbConfig.load(in);
				this.getServletContext()
						.setAttribute("plhdb_config", plhdbConfig);
			} catch (FileNotFoundException e) {
				log().error("failed to find the file: " + file, e);
				throw new RuntimeException("failed to find the file: "
						+ file, e);
			} catch (IOException e) {
				log().error("failed to load the configration file: " + file, e);
				throw new RuntimeException(
						"failed to load the configration file: " + file, e);
			} finally {
				if (in != null) {
					try {
						in.close();
					} catch (IOException ex) {
						log().error("failed to close the file: " + file, ex);
						// ignore otherwise
					}
				}
			}
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.springframework.web.servlet.DispatcherServlet#doDispatch(javax.servlet
	 * .http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
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
	@Override
	protected void doService(HttpServletRequest request,
                                 HttpServletResponse response) 
            throws Exception {

		String studyid = request.getParameter("studyid");
			String uri = request.getRequestURI();
			if (uri.indexOf("login.go") > -1) {
				setActiveMenu("login", request);
				super.doService(request, response);
			}else if (uri.indexOf("MOU") > -1)
                            // FIXME: needs to be config parameter!
				response.sendRedirect("https://goo.gl/qYU9lx");
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
				setActiveMenu("edit", request);
				super.doService(request, response);
			} else if (uri.indexOf("search/biography.go") > -1) {
				setActiveMenu("search_biography", request);
				super.doService(request, response);
			} else if (uri.indexOf("search/fertility.go") > -1) {
				setActiveMenu("search_fertility", request);
				super.doService(request, response);
			} else if (uri.indexOf("download.go") > -1) {
				PermissionManager manager = (PermissionManager) request
				.getSession().getAttribute("permission_manager");
				if(manager!=null){
					String f = request.getParameter("f");
					if(f==null || f.equals("")){
						throw new IllegalArgumentException("no file specified");
					}
					
					String root = plhdbConfig.getProperty("Report_Folder");
					if(root==null){
						throw new RuntimeException("No report folder found in the configuration file.");
					}
					String file =root+ (root.endsWith("/")?"":"/") + f;
					try{
						DownloadFile.downloadFile(response,new File(file), true);
					}catch(Exception e){
						throw new RuntimeException("failed to download the file: "+file,e);
					}
				}else{
					throw new AccessControlException(
					"Sorry! you do not have the authority.");
				}
				
			} else {

				PermissionManager manager = (PermissionManager) request
						.getSession().getAttribute("permission_manager");
				Boolean isadmin = (Boolean) request.getSession().getAttribute("isadmin");
				if (manager == null) {
					request.getSession().setAttribute("Message",
							"You have not logged in. Login please!");
					response.sendRedirect("/jsp/login.jsp");
				} else {
					if (uri.indexOf("view/users.go") != -1
							|| uri.indexOf("view/user.go") != -1
							|| uri.indexOf("save/user.go") != -1
							|| uri.indexOf("delete/user.go") != -1
							|| uri.indexOf("add/user.go") != -1
							|| uri.indexOf("edit/user.go") != -1) {
						setActiveMenu("users", request);
						if (isadmin) {
							super.doService(request, response);
						} else {
							throw new AccessControlException(
									"Sorry! you do not have the authority.");
						}
					} else {
						setActiveMenu("edit", request);
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

	private void setActiveMenu(String menu, HttpServletRequest request) {
		request.setAttribute("active_menu", menu);
	}
}
