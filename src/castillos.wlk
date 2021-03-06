class Castillos{
	var property rey
	var property lBurocratas = []
	var property guardias = []
	var property estabilidad = 1000
	var property defensas = 0
	var property murallas = 0
	var property ambientes = []
	method fiesta(){
		if (self.aptoParaFiesta()){
			self.guardias().forEach({g => g.agotamiento(g.agotamiento() + 8)}) 
			self.lBurocratas().forEach({b => b.panico(false)})
		}
	}
	method aptoParaFiesta(){
		return estabilidad > 100*1.25
	}
	method alimentarGuardias(cocinero){
		self.guardias().forEach({g => g.agotamiento(g.agotamiento() + cocinero.servirPlato() ) })
	}

	method castilloDerrotado(){
		return estabilidad < 100
	}
	method agregarGuardia(nuevoG){		
		self.guardias().add(nuevoG)
	}
	method agregarBurocratas(nuevoB){		
		self.lBurocratas().add(nuevoB)
	}
	method prepararDefensas(){
		//Sube defensas
		defensas = defensas+ self.guardias().sum({a => a.capacidad()})+  (self.lBurocratas().sum({exp => exp.condicionAporte()}) *  self.lBurocratas().size() )

		//se agotan en base al ambiente de donde vienen	
		self.guardias().forEach({g => g.agotamiento(g.agotamiento() - g.ambiente().puntajeHabitacion() ) })	
	}
}

class Guardias{
	var property capacidad = 10
	var property agotamiento = 10
	var property ambiente = salon
}

class Burocratas{
	var property nombre = ""
	var property fNacimiento = 1060
	var property experiencia = 0
	var property panico = false

	method condicionAporte(){
		if (panico){
			return 0
		} else {
			return experiencia
		}
	}
	method esJoven(){
		return fNacimiento < 1000
	}

}

class Rey{
	var property name = ""
	//decide a quien ataca
	method organizaFiesta(castillo){
		castillo.fiesta()
	}
	method atacar(castilloAAtacar, castilloDelRey){
		const cAtacado = castilloAAtacar
		const resistencia = castilloAAtacar.murallas() + castilloAAtacar.ambientes().sum({g => g.puntajeHabitacion()})
		var victoria = false
		victoria = (castilloAAtacar.defensas() + resistencia) < (castilloDelRey.guardias().sum({g => g.capacidad()}) * 3)
		if (victoria) {
			cAtacado.estabilidad(cAtacado.estabilidad() -  castilloDelRey.guardias().sum({g => g.capacidad()}))
		}
		castilloAAtacar.lBurocratas().forEach({lb =>
			if (lb.esJoven()){
				lb.panico(true)
			} 
		})				 
	}
}
object carneCiervo{
	method valorNutritivo(){
		return 7
	}
}
object carneCalamar{
	method valorNutritivo(){
		return 7
	}
}

class Cocineros{
	var property plato 
	method servirPlato(){
		return plato.valorNutritivo()						
	}
}

object todocastillos{
	var property listadoCastillos = []
	method agregarCastillos(castle){
		listadoCastillos.add(castle)
	}
}

object salon{
	method puntajeHabitacion(){
		return 5
	}
}

object torre{
	method puntajeHabitacion(){
		return 8
	}
}

object cuartel{
    const guardia=[]

    method reclutar(){
        guardia.add(new Guardias(capacidad =50,agotamiento= 0, ambiente = 10))
    }
    method guardia() = guardia
    method puntajeHabitacion(){
        return 10
    }
}

object salaDeReuniones{        //se reclutan burocratas
    const burocrata=[]
    method aliarBurocrata(){
    burocrata.add(new Burocratas(fNacimiento = 1060, experiencia=0))

    }
    method burocrata()= burocrata
    method puntajeHabitacion(){
        return 6
    }
}

//El uso de clases es muy ??til cuando tenemos varios objetos que se comportan de manera similar 

