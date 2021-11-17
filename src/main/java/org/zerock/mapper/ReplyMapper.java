package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {

	public Long insert(ReplyVO vo);
	
	public ReplyVO read(Long bno);
	
	public int delete (int rno);
	
	public int update(ReplyVO reply);
	
	public List<ReplyVO> getListWithPageing(@Param("cri") Criteria cri, @Param("bno") Long bno);
}
