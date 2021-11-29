package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {

	void register(BoardVO board);
	
	BoardVO get(long bno);
	
	boolean modify(BoardVO board);
	
	boolean remove(long bno);
	
	List<BoardVO> getList();
	
	List<BoardVO> getList(Criteria cri);
	
	int getTotal(Criteria cri);
	
	List<BoardAttachVO> getAttachList(Long bno);
}
