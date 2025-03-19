package com.care.boot.member;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.care.boot.PageService;

import jakarta.servlet.http.HttpSession;

@Service
public class MemberService {
    @Autowired private IMemberMapper mapper;
    @Autowired private HttpSession session;
    
    public String registProc(MemberDTO member) {
        if(member.getId() == null || member.getId().trim().isEmpty()) {
            return "아이디를 입력하세요.";
        }
        if(member.getPw() == null || member.getPw().trim().isEmpty()) {
            return "비밀번호를 입력하세요.";
        }
        if(!member.getPw().equals(member.getConfirm())) {
            return "두 비밀번호를 일치하여 입력하세요.";
        }
        if(member.getUserName() == null || member.getUserName().trim().isEmpty()) {
            return "이름을 입력하세요.";
        }

        MemberDTO check = mapper.login(member.getId());
        if(check != null) {
            return "이미 사용중인 아이디 입니다.";
        }

        /* 암호화 과정 */
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String secretPass = encoder.encode(member.getPw());
        member.setPw(secretPass);

        int result = mapper.registProc(member);
        return (result == 1) ? "회원 등록 완료" : "회원 등록을 다시 시도하세요.";
    }

    // ✅ 반환 타입 변경 (String → MemberDTO)
    public MemberDTO login(String id, String pw) {
        if(id == null || id.trim().isEmpty()) return null;
        if(pw == null || pw.trim().isEmpty()) return null;

        MemberDTO check = mapper.login(id);
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        if (check != null && encoder.matches(pw, check.getPw())) {
            return check; // ✅ 로그인 성공 시 MemberDTO 반환
        }
        return null; // 로그인 실패
    }

    public void memberInfo(String select, String search, String cp, Model model) {
        int currentPage = 1;
        try {
            currentPage = Integer.parseInt(cp);
        } catch (Exception e) {
            currentPage = 1;
        }

        if (select == null) select = "";

        int pageBlock = 3;
        int end = pageBlock * currentPage;
        int begin = end - pageBlock + 1;

        ArrayList<MemberDTO> members = mapper.memberInfo(begin, end, select, search);
        int totalCount = mapper.totalCount(select, search);
        if (totalCount == 0) return;

        String url = "memberInfo?select=" + select + "&search=" + search + "&currentPage=";
        String result = PageService.printPage(url, totalCount, pageBlock, currentPage);

        model.addAttribute("select", select);
        model.addAttribute("search", search);
        model.addAttribute("result", result);
        model.addAttribute("members", members);
    }

    public String userInfo(String id, Model model) {
        String sessionId = (String)session.getAttribute("id");
        if (sessionId == null) return "로그인 후 이용하세요.";

        if (!sessionId.equals("admin") && !sessionId.equals(id)) {
            return "본인의 아이디를 선택하세요.";
        }

        MemberDTO member = mapper.login(id);
        if (member.getAddress() != null && !member.getAddress().isEmpty()) {
            String[] address = member.getAddress().split(",");
            if (address.length >= 2) {
                model.addAttribute("postcode", address[0]);
                member.setAddress(address[1]);
                if (address.length == 3) {
                    model.addAttribute("detailAddress", address[2]);
                }
            }
        }
        model.addAttribute("member", member);
        return "회원 검색 완료";
    }

    public String updateProc(MemberDTO member) {
        if (member.getPw() == null || member.getPw().trim().isEmpty()) {
            return "비밀번호를 입력하세요.";
        }
        if (!member.getPw().equals(member.getConfirm())) {
            return "두 비밀번호를 일치하여 입력하세요.";
        }
        if (member.getUserName() == null || member.getUserName().trim().isEmpty()) {
            return "이름을 입력하세요.";
        }

        /* 암호화 과정 */
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String secretPass = encoder.encode(member.getPw());
        member.setPw(secretPass);

        int result = mapper.updateProc(member);
        return (result == 1) ? "회원 수정 완료" : "회원 수정을 다시 시도하세요.";
    }

    public String deleteProc(MemberDTO member) {
        if (member.getPw() == null || member.getPw().trim().isEmpty()) {
            return "비밀번호를 입력하세요.";
        }
        if (!member.getPw().equals(member.getConfirm())) {
            return "두 비밀번호를 일치하여 입력하세요.";
        }

        MemberDTO check = mapper.login(member.getId());
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        if (check != null && encoder.matches(member.getPw(), check.getPw())) {
            int result = mapper.deleteProc(member.getId());
            return (result == 1) ? "회원 삭제 완료" : "회원 삭제를 다시 시도하세요.";
        }

        return "아이디 또는 비밀번호를 확인 후 입력하세요.";
    }
}


















