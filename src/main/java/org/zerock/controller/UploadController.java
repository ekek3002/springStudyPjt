package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		
		String uploadFolder = "/Users/yellowin/workspace/study/spring/upload";
		for (MultipartFile multipartFile : uploadFile) {
			
			log.info("--------------------------------");
			log.info("Upload File Name : "+multipartFile.getOriginalFilename());
			log.info("Upload File Size: "+multipartFile.getSize());
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		
		String str = sdf.format(date);
		
		return str.replace("-", File.separator);
	}
	
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return false;
	}
	
//	@PostMapping("/uploadAjaxAction")
//	public void uploadAjaxActionPost(MultipartFile[] uploadFile) {
//		log.info("update ajax post........");
//		String uploadFolder = "/Users/yellowin/workspace/study/spring/upload";
//		
//		//make folder
//		File uploadPath = new File(uploadFolder, getFolder());
//		log.info("upload path: "+uploadPath);
//		
//		if (uploadPath.exists() == false) {
//			uploadPath.mkdirs();
//		}
//		// make yyyy/MM/dd folder
//		
//		for (MultipartFile multipartFile : uploadFile) {
//			log.info("--------------------------------");
//			log.info("Upload File Name : "+multipartFile.getOriginalFilename());
//			log.info("Upload File Size: "+multipartFile.getSize());
//			
//			String uploadFileName = multipartFile.getOriginalFilename();
//			
//			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1);
//			log.info("only file name: "+uploadFileName);
//			
//			UUID uuid = UUID.randomUUID();
//			
//			uploadFileName = uuid.toString()+"_"+uploadFileName;
//			
//			
//			try {
//				//File saveFile = new File(uploadFolder, uploadFileName);
//				File saveFile = new File(uploadPath, uploadFileName);
//				multipartFile.transferTo(saveFile);
//				
//				//check image type file
//				if (checkImageType(saveFile)) {
//					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
//					
//					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
//					
//					thumbnail.close();
//				}
//			} catch (Exception e) {
//				log.error(e.getMessage());
//			}
//		}
//	}
	
	//AttachFileDTO 반환 구
//	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	public ResponseEntity<List<AttachFileDTO>> uploadAjaxActionPost(MultipartFile[] uploadFile) {
//		log.info("update ajax post........");
//		
//		List<AttachFileDTO> list = new ArrayList<>();
//		String uploadFolder = "/Users/yellowin/workspace/study/spring/upload";
//		
//		String uploadFolderPath = getFolder();
//		//make folder
//		File uploadPath = new File(uploadFolder, uploadFolderPath);
//		log.info("upload path: "+uploadPath);
//		
//		if (uploadPath.exists() == false) {
//			uploadPath.mkdirs();
//		}
//		// make yyyy/MM/dd folder
//		
//		for (MultipartFile multipartFile : uploadFile) {
//			
//			log.info("--------------------------------");
//			log.info("Upload File Name : "+multipartFile.getOriginalFilename());
//			log.info("Upload File Size: "+multipartFile.getSize());
//			
//			AttachFileDTO attachDTO = new AttachFileDTO();
//			
//			String uploadFileName = multipartFile.getOriginalFilename();
//			
//			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1);
//			log.info("only file name: "+uploadFileName);
//			attachDTO.setFileName(uploadFileName);
//			
//			UUID uuid = UUID.randomUUID();
//			
//			uploadFileName = uuid.toString()+"_"+uploadFileName;
//			
//			
//			try {
//				//File saveFile = new File(uploadFolder, uploadFileName);
//				File saveFile = new File(uploadPath, uploadFileName);
//				multipartFile.transferTo(saveFile);
//				
//				attachDTO.setUuid(uuid.toString());
//				attachDTO.setUploadPath(uploadFolderPath);
//				
//				//check image type file
//				if (checkImageType(saveFile)) {
//					attachDTO.setImage(true);
//					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
//					
//					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
//					
//					thumbnail.close();
//				}
//				
//				list.add(attachDTO);
//			} catch (Exception e) {
//				log.error(e.getMessage());
//			}
//		}
//		return new ResponseEntity<>(list, HttpStatus.OK);
//	}
	//로그인 회원만 업로드 가능하도록 수정
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		log.info("update ajax post........");
		
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "/Users/yellowin/workspace/study/spring/upload";
		
		String uploadFolderPath = getFolder();
		//make folder
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("upload path: "+uploadPath);
		
		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		// make yyyy/MM/dd folder
		
		for (MultipartFile multipartFile : uploadFile) {
			
			log.info("--------------------------------");
			log.info("Upload File Name : "+multipartFile.getOriginalFilename());
			log.info("Upload File Size: "+multipartFile.getSize());
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1);
			log.info("only file name: "+uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			
			
			try {
				//File saveFile = new File(uploadFolder, uploadFileName);
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				//check image type file
				if (checkImageType(saveFile)) {
					attachDTO.setImage(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					
					thumbnail.close();
				}
				
				list.add(attachDTO);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("fileName: "+fileName);
		
		File file = new File("/Users/yellowin/workspace/study/spring/upload/"+fileName);
		
		log.info("file: "+file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
//	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
//	@ResponseBody
//	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
//		log.info("download file: "+fileName);
//		Resource resource = new FileSystemResource("/Users/yellowin/workspace/study/spring/upload/"+fileName);
//		log.info("resource: "+resource);
//		
//		if (resource.exists() == false) {
//			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
//		}
//		
//		String resourceName = resource.getFilename();
//		HttpHeaders headers = new HttpHeaders();
//		
//		try {
//			String downloadName = null;
//			if (userAgent.contains("Trident")) {
//				log.info("IE browser");
//				
//				downloadName = URLEncoder.encode(resourceName, "UTF-8").replaceAll("\\+", "");
//			} else if (userAgent.contains("Edge")) {
//				log.info("Edge browser");
//				downloadName = URLEncoder.encode(resourceName, "UTF-8");
//				log.info("Edge name : "+downloadName);
//			} else {
//				log.info("Chrome browser");
//				downloadName = new String(resourceName.getBytes("UTF-8"),"ISO-8859-1");
//			}
//			headers.add("Content-Disposition", "attachment; filename="+downloadName);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
//	}
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		log.info("download file: "+fileName);
		Resource resource = new FileSystemResource("/Users/yellowin/workspace/study/spring/upload/"+fileName);
		log.info("resource: "+resource);
		
		if (resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		String resourceName = resource.getFilename();
		
		//remove uuid
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName = null;
			if (userAgent.contains("Trident")) {
				log.info("IE browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", "");
			} else if (userAgent.contains("Edge")) {
				log.info("Edge browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
				log.info("Edge name : "+downloadName);
			} else {
				log.info("Chrome browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1");
			}
			
			log.info("downloadName: "+downloadName);
			headers.add("Content-Disposition", "attachment; filename="+downloadName);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("deleteFile: "+fileName);
		
		File file;
		
		try {
			file = new File("/Users/yellowin/workspace/study/spring/upload/"+URLDecoder.decode(fileName,"UTF-8"));
			
			file.delete();
			
			if (type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("largeFileName: "+largeFileName);
				file = new File(largeFileName);
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
	
}
