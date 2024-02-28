//
//  HelpViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

class HelpViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let steps = [
        "Cihazı ve Uygulamayı ilk açtığınızda CİHAZ BAĞLANTI tuşuna basarak cihazı bağlayabilir ya da nokta seçim ekranında gelen uyarı kutucuğu ile bağlantıları yapabilirsiniz.",
        "EĞER SONUÇLARI bilgisayara gönderecekseniz, göndereceğiniz bilgisayarın IP değerini uygulamaya girmeniz gerekmektedir.",
        "TEST sayfasında önce test yapılacak aracın tipi seçilir, plaka numarası ve diğer bilgiler girilir. KAYDET tuşuna basılınca test edilecek aracın ilk görüntüsü ekrana gelir. Araç üzerinde test yapmak istediğiniz yere Telefon veya Tablet üzerinde elinizle veya kalem ile bir işaret koyun. Yeşil Yazı ile CİHAZI OKUTUNUZ gördükten sonra cihaz ile araç üzerinde işaretlenen noktada ölçüm yapın. Eğer yanlış ölçüm yapıldı ise silip tekrar ölçüm alabilirsiniz.",
        "İleri ve geri tuşları ile bir sonraki veya bir önceki araç görüntüsüne gidilir. Ok şeklindeki geri işaretine basıldığında ise sırasıyla en son konulan nokta ve o nokta için yapılan ölçümler silinir.",
        "Ekranda her bölümün altında bulunan kırmızı ok tuşuna basarak o bölümün hasar durumunu seçebilirsiniz.",
        "Araç üzerinde bütün ölçümler bitince ve aracın üst görünümünde iken BİTİR tuşuna basılınca, sonuçlar kaydedilir ve test sonuçlarının göründüğü ekrana gelirsiniz.",
        "DÜZENLE tuşu ile araç üzerinde yeni ölçümler yapabilir veya bazı noktaları en son noktadan başlayarak silebilirsiniz.",
        "FOTOĞRAF tuşuna basarak aracın 4 adet fotoğrafını çekebilirsiniz.",
        "NOTE Tuşuna basarak ekspertiz notları ekleyebilirsiniz.",
        "PAYLAŞ tuşuna basarak test raporunu whatsapp veya mail gönderebilirsiniz.",
        "GÖNDER tuşuna basıldığı zaman tüm araç görüntüleri ve ölçüm sonuçları bilgisayara veya varsa kablosuz bir yazıcıya gönderilir. Bunun için bilgisayarınıza özel yazılım yüklenmesi gerekir",
        "Ana sayfada ARŞİV tuşuna basılırsa, daha önce test edilen araçların listesi görüntülenir ve buradan istediğiniz aracı seçip, sonuçlarına bakabilir, düzenleme yapabilir ve tekrar müşteriye gönderebilirsiniz.",
        "Arşiv sayfasında iken araçların sağ alt tarafında bulunan çöp tuşuna basarsanız o aracın tüm bilgileri silinir."
    ]
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Yardım"
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = steps[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

