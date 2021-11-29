package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.RequiredArgsConstructor;
import lombok.ToString;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@RequiredArgsConstructor
@ToString
public class BoardServiceImpl  implements BoardService{

	private final BoardMapper mapper;
	private final BoardAttachMapper attachMapper;

//	@Override
//	public Long register(BoardVO board) {
//		mapper.insertSelectKey(board);
//		return board.getBno();
//	}

	@Override
	public BoardVO get(long bno) {
		return mapper.read(bno);
	}

//	@Override
//	public int modify(BoardVO board) {
//		return mapper.update(board);
//	}
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify........"+board);
		attachMapper.deleteAll(board.getBno());
		boolean modifyResult = mapper.update(board)==1;
		
		if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

//	@Override
//	public int remove(long bno) {
//		return mapper.delete(bno);
//	}
	@Transactional
	@Override
	public boolean remove(long bno) {
		
		log.info("remove....."+bno);
		attachMapper.deleteAll(bno);
		return mapper.delete(bno) == 1;
	}

	@Override
	public List<BoardVO> getList() {
		return mapper.getList();
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		return mapper.getTotalCount(cri);
	}
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("register.........."+board);
		mapper.insertSelectKey(board);
		
		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
//		return board.getBno();
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno"+bno);
		return attachMapper.findByBno(bno);
	}
	
}
 