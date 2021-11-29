package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {

	private Long bno;
	private String title, content, writer;
	private Date regdate, updatedate;
	
	private int replycnt;
	
	private List<BoardAttachVO> attachList;
}
