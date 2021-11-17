package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {

	Long register(BoardVO board);
	
	BoardVO get(long bno);
	
	int modify(BoardVO board);
	
	int remove(long bno);
	
	List<BoardVO> getList();
	
	List<BoardVO> getList(Criteria cri);
	
	int getTotal(Criteria cri);
}
