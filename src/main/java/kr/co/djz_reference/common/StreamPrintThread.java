package kr.co.djz_reference.common;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
