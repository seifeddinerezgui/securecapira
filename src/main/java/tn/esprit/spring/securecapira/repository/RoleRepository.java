package tn.esprit.spring.securecapira.repository;

import tn.esprit.spring.securecapira.domain.Role;

import java.util.Collection;

public interface RoleRepository<T extends Role> {
    /*Basic CRUD operation*/
    T create(T data) ;
    Collection<T> list(int page, int pageSize);
    T get(Long id) ;
    T update(T data) ;
    Boolean delete(Long id) ;
    /*More complex operations*/
    void addRoleToUser(Long userId, String roleName);
    Role getRoleByUserId(long userId);
    Role getRoleByUserEmail(String email);
    void updateUserRole(long userId, String roleName);
}
