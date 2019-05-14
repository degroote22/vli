// Declaração de interfaces que tem que ser cumpridas para o location_getter
// Isso deve ser implementado pelo ambiente host (web ou mobile)

abstract class LocationResponse {
  final double latitude;
  final double longitude;

  LocationResponse(this.latitude, this.longitude);
}

typedef Future<LocationResponse> LocationGetterDef();
