package com.care.boot.member;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class MemberController {
    @Autowired private MemberService service;
    @Autowired private HttpSession session;

    @RequestMapping("regist")
    public String regist() {
        return "member/regist";
    }

    @PostMapping("registProc")
    public String registProc(MemberDTO member, Model model, RedirectAttributes ra) {
        String msg = service.registProc(member);
        if (msg.equals("회원 등록 완료")) {
            ra.addFlashAttribute("msg", msg);
            return "redirect:index";
        }
        model.addAttribute("msg", msg);
        return "member/regist";
    }

    @RequestMapping("login")
    public String login() {
        return "member/login";
    }

    @PostMapping("loginProc")
    public String loginProc(String id, String pw, Model model, RedirectAttributes ra) {
        MemberDTO loginUser = service.login(id, pw);

        if (loginUser != null) {
            session.setAttribute("loginUser", loginUser); // ✅ 세션 통일
            ra.addFlashAttribute("msg", "로그인 성공");
            return "redirect:/game";
        }

        model.addAttribute("msg", "로그인 실패! 아이디 또는 비밀번호를 확인하세요.");
        return "member/login";
    }

    @RequestMapping("logout")
    public String logout(RedirectAttributes ra) {
        session.invalidate();
        ra.addFlashAttribute("msg", "로그아웃 완료");
        return "redirect:index";
    }

    @RequestMapping("update")
    public String update() {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:login";
        return "member/update";
    }

    @PostMapping("updateProc")
    public String updateProc(MemberDTO member, Model model) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:login";

        member.setId(loginUser.getId());
        String msg = service.updateProc(member);
        if (msg.equals("회원 수정 완료")) {
            session.invalidate();
            return "redirect:index";
        }

        model.addAttribute("msg", msg);
        return "member/update";
    }

    @RequestMapping("delete")
    public String delete() {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:login";
        return "member/delete";
    }

    @PostMapping("deleteProc")
    public String deleteProc(MemberDTO member, Model model) {
        MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:login";

        member.setId(loginUser.getId());
        String msg = service.deleteProc(member);
        if (msg.equals("회원 삭제 완료")) {
            session.invalidate();
            return "redirect:index";
        }

        model.addAttribute("msg", msg);
        return "member/delete";
    }
}
