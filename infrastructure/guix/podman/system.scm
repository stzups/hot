(use-modules (gnu bootloader)
             (gnu bootloader grub)
             (gnu system file-systems)
             (gnu packages ssh)
             (gnu packages certs)
             (gnu services base)
             (gnu services networking)
             (gnu services desktop)
             (gnu services ssh)
             (gnu services docker)
             (guix gexp))

(operating-system
  (host-name "podman")
  (bootloader (bootloader-configuration (bootloader grub-bootloader)))
  (file-systems %base-file-systems)
  #|
  (packages
    (append
      (list nss-certs) ; docker requires https
      %base-packages))|#
  (services
    (append
      (list (service dhcp-client-service-type)
            ; make acpi shutdown work
            (service elogind-service-type)
            (service openssh-service-type
                     (openssh-configuration
                      (openssh openssh-sans-x)
                      (permit-root-login `prohibit-password)
                      (password-authentication? #f)
                      (authorized-keys
                       `(("root" ,(local-file "../id_ed25519.pub"))))))
            ; docker!
            (service docker-service-type))
      %base-services)))