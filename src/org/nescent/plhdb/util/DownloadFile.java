package org.nescent.plhdb.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.net.URLConnection;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

public class DownloadFile {

	private static final Logger log = Logger.getLogger(DownloadFile.class);

	/**
	 * Send the given file as a byte array to the servlet response. If
	 * attachment is set to true, then show a "Save as" dialogue, else show the
	 * file inline in the browser or let the operating system open it in the
	 * right application.
	 * 
	 * @param response
	 *            The HttpServletResponse to be used.
	 * @param bytes
	 *            The file contents in a byte array.
	 * @param fileName
	 *            The file name.
	 * @param attachment
	 *            Download as attachment?
	 */
	public static void downloadFile(HttpServletResponse response, byte[] bytes,
			String fileName, boolean attachment) throws IOException {
		// Wrap the byte array in a ByteArrayInputStream and pass it through
		// another method.
		downloadFile(response, new ByteArrayInputStream(bytes), fileName,
				attachment);
	}

	/**
	 * Send the given file as a File object to the servlet response. If
	 * attachment is set to true, then show a "Save as" dialogue, else show the
	 * file inline in the browser or let the operating system open it in the
	 * right application.
	 * 
	 * @param response
	 *            The HttpServletResponse to be used.
	 * @param file
	 *            The file as a File object.
	 * @param attachment
	 *            Download as attachment?
	 */
	public static void downloadFile(HttpServletResponse response, File file,
			boolean attachment) throws IOException {
		// Prepare stream.
		BufferedInputStream input = null;

		try {
			// Wrap the file in a BufferedInputStream and pass it through
			// another method.
			input = new BufferedInputStream(new FileInputStream(file));
			downloadFile(response, input, file.getName(), attachment);
		} catch (IOException e) {
			throw e;
		} finally {
			// Gently close stream.
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
					log.error("Download failed.", e);
				}
			}
		}
	}

	/**
	 * Send the given file as an InputStream to the servlet response. If
	 * attachment is set to true, then show a "Save as" dialogue, else show the
	 * file inline in the browser or let the operating system open it in the
	 * right application.
	 * 
	 * @param response
	 *            The HttpServletResponse to be used.
	 * @param input
	 *            The file contents in an InputStream.
	 * @param fileName
	 *            The file name.
	 * @param attachment
	 *            Download as attachment?
	 */
	public static void downloadFile(HttpServletResponse response,
			InputStream input, String fileName, boolean attachment)
			throws IOException {
		// Prepare stream.
		BufferedOutputStream output = null;

		try {
			// Prepare.
			int contentLength = input.available();
			String contentType = URLConnection
					.guessContentTypeFromName(fileName);
			String disposition = attachment ? "attachment" : "inline";

			// Init servlet response.
			response.setContentLength(contentLength);
			response.setContentType(contentType);
			response.setHeader("Content-disposition", disposition
					+ "; filename=\"" + fileName + "\"");
			output = new BufferedOutputStream(response.getOutputStream());

			// Write file contents to response.
			while (contentLength-- > 0) {
				output.write(input.read());
			}

			// Finalize task.
			output.flush();
		} catch (IOException e) {
			throw e;
		} finally {
			// Gently close stream.
			if (output != null) {
				try {
					output.close();
				} catch (IOException e) {
					e.printStackTrace();
					log.error("Download failed.", e);
				}
			}
		}
	}

	/**
	 * download data in CSV format.
	 * 
	 * @param response
	 * @param fileName
	 * @param delimitor
	 * @param headers
	 * @param dataList
	 * @throws IOException
	 */
	public static void downloadDateAsCSV(HttpServletResponse response,
			String fileName, String delimitor, String[] headers,
			List<Object> dataList) {
		response.reset();
		response.setContentType("application/text");
		response.setHeader("Content-disposition", "attachment; filename="
				+ fileName);

		BufferedWriter output = null;
		try {

			if (dataList != null) {
				output = new BufferedWriter(new OutputStreamWriter(response
						.getOutputStream()));
				output.write("Total number of records: " + dataList.size()
						+ "\n");
				if (headers != null) {
					String header = "";
					for (int i = 0; i < headers.length; i++) {
						if (headers[i] != null) {
							header += "\"" + headers[i] + "\"";
						} else {
							header += "";
						}
						if (i < headers.length - 1)
							header += delimitor;
					}
					header += "\n";
					output.write(header);
				}

				for (int i = 0; i < dataList.size(); i++) {
					Object[] row = (Object[]) dataList.get(i);
					String s = "";
					for (int j = 0; j < row.length; j++) {
						if (row[j] != null) {
							s += "\"" + row[j].toString() + "\"";
						} else {
							s += "";
						}
						if (j < row.length - 1)
							s += delimitor;
					}
					output.write(s + "\n");
				}
			} else {
				output.write("null data list\n");
			}
			output.flush();
			output.close();
		} catch (IOException e) {
			try {
				output.write(e.getMessage());
			} catch (Exception ie) {
			}

		} finally {
			// Gently close stream.
			if (output != null) {
				try {
					output.close();
				} catch (IOException e) {
					e.printStackTrace();
					log.error("Download failed.", e);
				}
			}
		}
	}
}
