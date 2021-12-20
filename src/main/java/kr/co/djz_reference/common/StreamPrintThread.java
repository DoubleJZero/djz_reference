package kr.co.djz_reference.common;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * StreamPrintThread
 *
 * @author DoubleJZero
 * @since 2021.12.16
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.16    DoubleJZero      최초생성
 *
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */
public class StreamPrintThread extends Thread {
	BufferedReader br = null;
	private static final Logger logger = LoggerFactory.getLogger(StreamPrintThread.class);

	public StreamPrintThread(InputStream is) {
		this.br = new BufferedReader(new InputStreamReader(is));
	}

	void close() {
		try {
			if (this.br != null) this.br.close();
		} catch (Exception e) {
			logger.warn(e.getMessage());
		}
	}

	public void run() {
		try {
			String line = null;

			while ((line = this.br.readLine()) != null) logger.info(line);

			close();
		} catch (Exception e) {
			logger.warn(e.getMessage());
			close();
		}
	}
}
