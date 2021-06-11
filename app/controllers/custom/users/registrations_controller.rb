require_dependency Rails.root.join('app', 'controllers', 'users', 'registrations_controller').to_s

class Users::RegistrationsController < Devise::RegistrationsController
  def get_balloted_heading_id(address)
    if address.include? "Topol pri Medvodah"
      return 1
    end
    if address.include? "Belo"
      return 1
    end
    if address.include? "Brezovica pri Medvodah"
      return 1
    end
    if address.include? "Tehovec"
      return 1
    end
    if address.include? "Trnovec"
      return 1
    end
    if address.include? "Setnica"
      return 1
    end
    if address.include? "Arharjeva ulica"
      return 2
    end
    if address.include? "Barletova cesta 2"
      return 2
    end
    if address.include? "Cesta komandanta Staneta"
      return 2
    end
    if address.include? "Cesta na Senico"
      return 2
    end
    if address.include? "Cesta na Svetje"
      return 2
    end
    if address.include? "Cesta ob Sori"
      return 2
    end
    if address.include? "Cesta talcev"
      return 2
    end
    if address.include? "Čarmanova ulica"
      return 2
    end
    if address.include? "Čelesnikova ulica"
      return 2
    end
    if address.include? "Dimčeva ulica"
      return 2
    end
    if address.include? "Donova cesta"
      return 2
    end
    if address.include? "Finžgarjeva ulica"
      return 2
    end
    if address.include? "Gorenjska cesta"
      return 2
    end
    if address.include? "Grajzerjeva ulica"
      return 2
    end
    if address.include? "Jamnikova ulica"
      return 2
    end
    if address.include? "Kebetova ulica"
      return 2
    end
    if address.include? "Klanska ulica"
      return 2
    end
    if address.include? "Kržišnikova ulica"
      return 2
    end
    if address.include? "Kuraltova ulica"
      return 2
    end
    if address.include? "Ostrovrharjeva ulica"
      return 2
    end
    if address.include? "Medvoška cesta"
      return 2
    end
    if address.include? "Podvizova ulica"
      return 2
    end
    if address.include? "Seškova cesta"
      return 2
    end
    if address.include? "Šetinova ulica"
      return 2
    end
    if address.include? "Šlosarjeva ulica"
      return 2
    end
    if address.include? "Šmalčeva ulica"
      return 2
    end
    if address.include? "Štalčeva ulica"
      return 2
    end
    if address.include? "Tehovnikova ulica"
      return 2
    end
    if address.include? "Trampuževa ulica"
      return 2
    end
    if address.include? "Turkova ulica"
      return 2
    end
    if address.include? "Ulica Ivanke Ovijač"
      return 2
    end
    if address.include? "Ulica k studencu"
      return 2
    end
    if address.include? "Ulica ob gozdu"
      return 2
    end
    if address.include? "Ulica Simona Jenka"
      return 2
    end
    if address.include? "Višnarjeva ulica"
      return 2
    end
    if address.include? "Zbiljska cesta"
      return 2
    end
    if address.include? "Žontarjeva ulica"
      return 2
    end
    if address.include? "Verje"
      return 3
    end
    if address.include? "Zgornje Pirniče"
      return 3
    end
    if address.include? "Spodnje Pirniče"
      return 3
    end
    if address.include? "Vikrče"
      return 3
    end
    if address.include? "Zavrh pod Šmarno goro"
      return 3
    end
    if address.include? "Barletova cesta"
      return 4
    end
    if address.include? "Bečanova ulica"
      return 4
    end
    if address.include? "Bergantova cesta"
      return 4
    end
    if address.include? "Bernikova ulica"
      return 4
    end
    if address.include? "Bizantova cesta"
      return 4
    end
    if address.include? "Bogatajeva ulica"
      return 4
    end
    if address.include? "Cesta ob železnici"
      return 4
    end
    if address.include? "Cesta v Bonovec"
      return 4
    end
    if address.include? "Cesta v Žlebe"
      return 4
    end
    if address.include? "Dobnikarjeva ulica"
      return 4
    end
    if address.include? "Hrastarjeva ulica"
      return 4
    end
    if address.include? "Iztokova ulica"
      return 4
    end
    if address.include? "Kalanova ulica"
      return 4
    end
    if address.include? "Kurirska cesta"
      return 4
    end
    if address.include? "Na Čerenu"
      return 4
    end
    if address.include? "Preška cesta"
      return 4
    end
    if address.include? "Škofjeloška cesta"
      return 4
    end
    if address.include? "Trilerjeva ulica"
      return 4
    end
    if address.include? "Spodnja Senica"
      return 5
    end
    if address.include? "Zgornja Senica"
      return 5
    end
    if address.include? "Ladja"
      return 5
    end
    if address.include? "Seničica"
      return 6
    end
    if address.include? "Golo Brdo"
      return 6
    end
    if address.include? "Smlednik"
      return 7
    end
    if address.include? "Valburga"
      return 7
    end
    if address.include? "Hraše"
      return 7
    end
    if address.include? "Dragočajna"
      return 7
    end
    if address.include? "Moše"
      return 7
    end
    if address.include? "Sora"
      return 8
    end
    if address.include? "Rakovnik"
      return 8
    end
    if address.include? "Dol"
      return 8
    end
    if address.include? "Osolnik"
      return 8
    end
    if address.include? "Vaše"
      return 9
    end
    if address.include? "Goričane"
      return 9
    end
    if address.include? "Zbilje"
      return 10
    end
    if address.include? "Studenčice"
      return 11
    end
    if address.include? "Žlebe"
      return 11
    end
  end

  def sign_up_params
    params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
    params[:user][:balloted_heading_id] = get_balloted_heading_id(params[:user][:address])
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation, :terms_of_service, :locale,
                                 :document_type, :document_number,
                                 :redeemable_code, :phone, :address, :is_anonymous, :data_consent,
                                 :balloted_heading_id)
  end
end
