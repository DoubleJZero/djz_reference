package kr.co.djz_reference.service;

import java.util.HashMap;
import java.util.Map;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.djz.service.DjzCbsService;

/**
 * mainService
 *
 * @author DoubleJZero
 * @since 2021.12.08
 * @version 1.0
 * @see
 * <pre>
 * &lt;&lt; 개정이력(Modification Information) &gt;&gt;
 *   수정일               수정자               수정내용
 *  ---------   ---------   -------------------------------
 *  2021.12.08    DoubleJZero      최초생성
 *
 * Copyright (C) by Djz All right reserved.
 * </pre>
 */

@Service("mainService")
@Transactional(rollbackFor = Exception.class, readOnly = true)
public class MainService extends DjzCbsService {
	String serviceId = "MAINSERVICE";

	//private static final Logger logger = LoggerFactory.getLogger(MainService.class);

	/**
	 * 메인조회
	 *
	 * @return
	 */
	public Map<String, Object> getMain() {

		return new HashMap<String, Object>();
	}

}