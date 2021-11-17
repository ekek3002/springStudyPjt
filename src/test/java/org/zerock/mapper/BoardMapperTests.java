package org.zerock.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	
	@Autowired
	private BoardMapper boardMapper;
	
	@Test
	public void testGetList() {
		log.info("-----------------");
		boardMapper.getList();
	}
	@Test
	public void testInsert() {
		BoardVO vo = new BoardVO();
		vo.setTitle("test 테스트");
		vo.setContent("centent 테스트");
		vo.setWriter("tester");
		boardMapper.insert(vo);
		log.info("----------------");
		log.info("after insert " + vo.getBno());
	}
	@Test
	public void testInsertSelectKey() {
		BoardVO vo = new BoardVO();
		vo.setTitle("AAAtest 테스트");
		vo.setContent("AAAcentent 테스트");
		vo.setWriter("tester");
		boardMapper.insertSelectKey(vo);
		log.info("----------------");
		log.info("after insert selectkey" + vo.getBno());
	}
	@Test
	public void testRead() {
		BoardVO vo = boardMapper.read(7L);
		log.info(vo);

	}
	@Test
	public void testDelete() {
		int count = boardMapper.delete(1L);
		log.info("count:	" + count);

	}
	@Test
	public void testUpdate() {
		BoardVO vo = new BoardVO();
		vo.setBno(8L);
		vo.setTitle("Update Title");
		vo.setContent("Updateed content");
		vo.setWriter("user00");
		log.info("count:	" + boardMapper.update(vo));

	}
	
	@Test
	public void testPageing() {
		Criteria cri = new Criteria();
		List<BoardVO> list = boardMapper.getListWithPaging(cri);
		
		list.forEach(b -> log.info(b));
	}
	
	@Test
	public void testSearch() {
		Criteria cri = new Criteria();
		
		cri.setKeyword("새로");
		cri.setType("TC");
		
		List<BoardVO> list = boardMapper.getListWithPaging(cri);
		
		list.forEach(b -> log.info(b));
	}
	

}
