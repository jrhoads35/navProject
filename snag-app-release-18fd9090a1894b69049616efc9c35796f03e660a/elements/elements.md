# Elements

Orbital elements are one way (along with a [PVT](ephemeris.md#creation-of-a-position-velocity-time-pvt)) of describing the orbital state of a satellite.

Orbital element sets may be specified as Kepler, or classical orbital elements sets, in terms of the semimajor axis, eccentricity, inclination, and so on. For orbits that are near-circular and inclined, the argument of perigee is poorly defined, so eccentricity and semimajor axis are replaced by [circular orbital elements](https://oraas.orekit.space/oraas-api-json-schema.html?json=%7B%22serviceUrl%22%3A%22%2Fpropagation%22%2C%22className%22%3A%22org.orekit.web.json.propagation.PropagationRequest%22%2C%22output%22%3A%22false%22%7D#orbitalData_orbitBulletin_circular_a), in which the Cartesian components of the eccentricity vector in the orbital plane, where the first axis is the direction of the ascending node. For orbits that are both near-equatorial and near-circular, the right ascension of the ascending node is also poorly defined. In this case, [equinoctial elements](https://oraas.orekit.space/oraas-api-json-schema.html?json=%7B%22serviceUrl%22%3A%22%2Fpropagation%22%2C%22className%22%3A%22org.orekit.web.json.propagation.PropagationRequest%22%2C%22output%22%3A%22false%22%7D#orbitalData_orbitBulletin_equinoctial_a) are used, in which the first component of the eccentricity vector is specified from the vernal equinox, and the inclination and RAAN are replaced by components of the ascending node direction multiplied by the tangent of half the inclination.

To create the different orbital elements sets, use one of the following.

## Kepler

The function `kepler_oes` creates a Kepler orbital element set. It has seven required arguments and one optional argument.

   | Argument name          | Description                                                              |
   |------------------------|--------------------------------------------------------------------------|
   | `epoch`                | Time associated with the element set                                     |
   | `semimajor_axis_m`     | Semimajor axis in meters                                                 |
   | `eccentricity`         | Eccentricity                                                             |
   | `inclination_deg`      | Inclination in degrees                                                   |
   | `raan_deg`             | Right ascension of the ascending node in degrees                         |
   | `argument_perigee_deg` | Argument of perigee in degrees                                           |
   | `time_element_deg`     | True or mean anomaly in degrees                                          |
   | `is_mean`              | Optional; `true` for mean anomaly and `false` (default) for true anomaly |

Example: `kepler_oes(nowutc, 1.0e7, 0.1, 62.0, 82, 221, 45)`.

## Circular

The function `circular_oes` creates a circular orbital element set, which has no singularity at eccentricity zero. It has seven required arguments and one optional argument.

   | Argument name          | Description                                                              |
   |------------------------|--------------------------------------------------------------------------|
   | `epoch`                | Time associated with the element set                                     |
   | `semimajor_axis_m`     | Semimajor axis in meters                                                 |
   | `eccentricity_x`       | Eccentricity vector component in the direction of the node               |
   | `eccentricity_y`       | Eccentricity vector component perpendicular to the node direction        |
   | `inclination_deg`      | Inclination in degrees                                                   |
   | `raan_deg`             | Right ascension of the ascending node in degrees                         |
   | `time_element_deg`     | True or mean anomaly in degrees                                          |
   | `is_mean`              | Optional; `true` for mean argument of latitude and `false` (default) for argument of latitude |

## Equinoctial

The function `equinoctial_oes` creates an equinoctial orbital element set, which has no singularity at eccentricity zero, nor at inclination zero. It has seven required arguments and one optional argument.

   | Argument name      | Description                                                               |
   |--------------------|---------------------------------------------------------------------------|
   | `epoch`            | Time associated with the element set                                      |
   | `semimajor_axis_m` | Semimajor axis in meters                                                  |
   | `eccentricity_x`   | Eccentricity vector component in the direction of the node                |
   | `eccentricity_y`   | Eccentricity vector component perpendicular to the node direction         |
   | `inclination_x`    | tan(i/2) cos(raan)                                                        |
   | `inclination_y`    | tan(i/2) sin(raan)                                                        |
   | `raan_deg`         | Right ascension of the ascending node in degrees                          |
   | `time_element_deg` | True or mean anomaly in degrees                                           |
   | `is_mean`          | Optional; `true` for mean longitude, `false` (default) for true longitude |

## Spacetrack
<!-- * `two_line_elements(line1, line2)` are the [two-line elements (TLE)](https://www.space-track.org/documentation#/tle) with each line given as a string (enclosed in a pair of double quotes). -->

Element sets published by [Space-track](spacetrack.md) are commonly called "[two-line elements](https://www.space-track.org/documentation#/tle)", or TLE for short. The component quantities are almost the same as Keplerian elements, but the semimajor axis is replaced with the mean motion (measured in revolutions per day). They are mean values using the [SGP4 orbit propagation](https://www.space-track.org/documentation#/sgp4) force model.
They are usually created by the function `spacetrack_orbit()`; the products of this function, however, have significantly more information than what is in a TLE.

## Conversion

### Orbital elements and Cartesian ECI

The four representations of orbital state may be converted to another of the four using the function `convert_orbit()`.

`convert_orbit(orbit, output_form, to_mean)`

   | Argument name | Description                                                                                |
   |---------------|--------------------------------------------------------------------------------------------|
   | `orbit`       | Orbital state to be converted                                                              |
   | `output_form` | Output representation, one of `st.cartesian`, `st.kepler`, `st.circular`, `st.equinoctial` |
   | `to_mean`     | Optional; whether to use the mean (`true`) or true (`false`) time element (default)        |

Example

	kpex = kepler_oes(nowutc, 1.0e7, 0.1, 62.0, 82, 221, 45)
	kpexpvt = convert_orbit(kpex, st.cartesian)
            epoch: 2023-07-09 15:57:00.000000
       position_m: [4198345.8528272 -1241359.61477107 -8144018.98618112]
      velocity_ms: [1367.29065405274 6620.2565983036 -813.644840017429]


### Spacetrack or two-line elements

TLEs may be converted to and from an ECI [Cartesian state (PVT)](ephemeris.md) or any of the elements listed above. This conversion takes into account the perturbations incorporated in the [SGP4 orbit propagation](https://www.space-track.org/documentation#/sgp4) force model. The result of converting a TLE to a PVT is therefore different from converting the two-body (osculating) elements. The conversion to a TLE requires the specification of a [force model](propagation.md#force-model) so that SGP4 mean elements may be fit to the ephemeris. Because of the need to propagate points and do a fit, this function can take a few seconds to produce an answer. While it is possible to call `to_tle()` for circular and equinoctial elements, if they are exactly singular, the function will fail.

`to_tle(orbit, force_model)`

   | Argument name | Description                                                                                  |
   |---------------|----------------------------------------------------------------------------------------------|
   | `orbit`       | Orbit to be converted                                                                        |
   | `force_model` | Optional; [force model](propagation.md#force-model) to use to propagate; default is two-body |

`from_tle(tle, output_form, to_mean)`

   | Argument name | Description                                                                             |
   |---------------|-----------------------------------------------------------------------------------------|
   | `tle`         | The spacetrack or TLE elements to be converted                                          |
   | `output_form` | Optional; one of `st.cartesian` (default), `st.kepler`, `st.circular`, `st.equinoctial` |
   | `to_mean`     | Optional; whether to use the mean (`true`) or true (`false`) time element (default)     |


Examples

	navstar82.orbit = spacetrack_orbit(55268)

	from_tle(navstar82.orbit)
            epoch: 2023-07-07 04:08:35.091000
       position_m: [11738136.436474 -12330087.7504896 20365988.7502014]
      velocity_ms: [3429.8450691273 1419.38389636161 -1116.5847998371]

	from_tle(navstar82.orbit,st.kepler,true)
                     epoch: 2023-07-07 04:08:35.091000
          semimajor_axis_m: 26559479.2712278
              eccentricity: 0.000606912178512541
           inclination_deg: 55.0440412966724
                  raan_deg: -169.657620289979
      argument_perigee_deg: 93.3365087295388
          mean_anomaly_deg: 17.2301642558942

	kpex = kepler_oes(nowutc, 1.0e7, 0.1, 62.0, 82, 221, 45)
	kpextle = to_tle(kpex)
	kpextle.tle
		line1: '1 00000U 00000A   23190.66458333  .00000000  00000-0 -27902-1 0    08'
		line2: '2 00000  61.9548  85.7122 1003686 220.9566  35.7795  8.68265021    08'
