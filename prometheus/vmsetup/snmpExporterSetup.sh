#!/bin/bash

# Binary
cd /tmp/
wget https://github.com/prometheus/snmp_exporter/releases/download/v0.20.0/snmp_exporter-0.20.0.linux-amd64.tar.gz
tar -xzvf snmp_exporter-0.20.0.linux-amd64.tar.gz 
mv /tmp/snmp_exporter-0.20.0.linux-amd64 /opt/snmp-exporter
rm /tmp/snmp_exporter-0.20.0.linux-amd64.tar.gz

# Service file
cat << EOF > /usr/lib/systemd/system/snmp-exporter.service
[Unit]
Description=SNMP Exporter
After=network.target

[Service]
WorkingDirectory=/opt/snmp-exporter
ExecStart=/opt/snmp-exporter/snmp_exporter
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Config
cat << 'EOF' > /opt/snmp-exporter/snmp.yml
dell_idrac:
  walk:
  - 1.3.6.1.4.1.674.10892.5.1.3
  - 1.3.6.1.4.1.674.10892.5.2
  - 1.3.6.1.4.1.674.10892.5.4.1100.30.1
  - 1.3.6.1.4.1.674.10892.5.4.1100.32.1
  - 1.3.6.1.4.1.674.10892.5.4.1100.50.1
  - 1.3.6.1.4.1.674.10892.5.4.1100.80.1
  - 1.3.6.1.4.1.674.10892.5.4.1100.90.1
  - 1.3.6.1.4.1.674.10892.5.4.2000.10.1
  - 1.3.6.1.4.1.674.10892.5.4.300.50.1
  - 1.3.6.1.4.1.674.10892.5.4.300.60.1
  - 1.3.6.1.4.1.674.10892.5.4.300.70.1
  - 1.3.6.1.4.1.674.10892.5.4.600.12.1
  - 1.3.6.1.4.1.674.10892.5.4.600.50.1
  - 1.3.6.1.4.1.674.10892.5.4.700.12.1.5
  - 1.3.6.1.4.1.674.10892.5.4.700.12.1.8
  - 1.3.6.1.4.1.674.10892.5.4.700.20.1
  - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1
  - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1
  - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1
  get:
  - 1.3.6.1.2.1.1.3.0
  - 1.3.6.1.4.1.674.10892.5.1.1.2.0
  - 1.3.6.1.4.1.674.10892.5.1.1.8.0
  - 1.3.6.1.4.1.674.10892.5.4.300.1.0
  metrics:
  - name: sysUpTime
    oid: 1.3.6.1.2.1.1.3
    type: gauge
    help: The time (in hundredths of a second) since the network management portion
      of the system was last re-initialized. - 1.3.6.1.2.1.1.3
  - name: racShortName
    oid: 1.3.6.1.4.1.674.10892.5.1.1.2
    type: DisplayString
    help: This attribute defines the short product name of a remote access card. -
      1.3.6.1.4.1.674.10892.5.1.1.2
  - name: racFirmwareVersion
    oid: 1.3.6.1.4.1.674.10892.5.1.1.8
    type: DisplayString
    help: This attribute defines the firmware version of a remote access card. - 1.3.6.1.4.1.674.10892.5.1.1.8
  - name: systemFQDN
    oid: 1.3.6.1.4.1.674.10892.5.1.3.1
    type: DisplayString
    help: This attribute defines the fully qualified domain name of the system - 1.3.6.1.4.1.674.10892.5.1.3.1
  - name: systemServiceTag
    oid: 1.3.6.1.4.1.674.10892.5.1.3.2
    type: DisplayString
    help: This attribute defines the service tag of the system. - 1.3.6.1.4.1.674.10892.5.1.3.2
  - name: systemExpressServiceCode
    oid: 1.3.6.1.4.1.674.10892.5.1.3.3
    type: DisplayString
    help: This attribute defines the express service code of the system. - 1.3.6.1.4.1.674.10892.5.1.3.3
  - name: systemAssetTag
    oid: 1.3.6.1.4.1.674.10892.5.1.3.4
    type: DisplayString
    help: This attribute defines the asset tag of the system. - 1.3.6.1.4.1.674.10892.5.1.3.4
  - name: systemBladeSlotNumber
    oid: 1.3.6.1.4.1.674.10892.5.1.3.5
    type: OctetString
    help: This attribute defines the slot number of the system in the modular chassis.
      - 1.3.6.1.4.1.674.10892.5.1.3.5
  - name: systemOSName
    oid: 1.3.6.1.4.1.674.10892.5.1.3.6
    type: OctetString
    help: This attribute defines the name of the operating system that the host is
      running. - 1.3.6.1.4.1.674.10892.5.1.3.6
  - name: systemFormFactor
    oid: 1.3.6.1.4.1.674.10892.5.1.3.7
    type: gauge
    help: This attribute defines the form factor of the system. - 1.3.6.1.4.1.674.10892.5.1.3.7
    enum_values:
      1: other
      2: unknown
      3: u1
      4: u2
      5: u4
      6: u7
      7: singleWidthHalfHeight
      8: dualWidthHalfHeight
      9: singleWidthFullHeight
      10: dualWidthFullHeight
      11: singleWidthQuarterHeight
      12: u5
      13: u1HalfWidth
      14: u1QuarterWidth
      15: u1FullWidth
  - name: systemDataCenterName
    oid: 1.3.6.1.4.1.674.10892.5.1.3.8
    type: DisplayString
    help: This attribute defines the Data Center locator of the system. - 1.3.6.1.4.1.674.10892.5.1.3.8
  - name: systemAisleName
    oid: 1.3.6.1.4.1.674.10892.5.1.3.9
    type: OctetString
    help: This attribute defines the Aisle locator of the system. - 1.3.6.1.4.1.674.10892.5.1.3.9
  - name: systemRackName
    oid: 1.3.6.1.4.1.674.10892.5.1.3.10
    type: OctetString
    help: This attribute defines the Rack locator of the system. - 1.3.6.1.4.1.674.10892.5.1.3.10
  - name: systemRackSlot
    oid: 1.3.6.1.4.1.674.10892.5.1.3.11
    type: OctetString
    help: This attribute defines the Rack Slot locator of the system. - 1.3.6.1.4.1.674.10892.5.1.3.11
  - name: systemModelName
    oid: 1.3.6.1.4.1.674.10892.5.1.3.12
    type: OctetString
    help: This attribute defines the model name of the system. - 1.3.6.1.4.1.674.10892.5.1.3.12
  - name: systemSystemID
    oid: 1.3.6.1.4.1.674.10892.5.1.3.13
    type: gauge
    help: This attribute defines the system ID of the system. - 1.3.6.1.4.1.674.10892.5.1.3.13
  - name: systemOSVersion
    oid: 1.3.6.1.4.1.674.10892.5.1.3.14
    type: OctetString
    help: This attribute defines the version of the operating system that the host
      is running. - 1.3.6.1.4.1.674.10892.5.1.3.14
  - name: systemRoomName
    oid: 1.3.6.1.4.1.674.10892.5.1.3.15
    type: OctetString
    help: This attribute defines the Room locator of the system. - 1.3.6.1.4.1.674.10892.5.1.3.15
  - name: systemChassisSystemHeight
    oid: 1.3.6.1.4.1.674.10892.5.1.3.16
    type: gauge
    help: This attribute defines the height of the system, in 'U's - 1.3.6.1.4.1.674.10892.5.1.3.16
  - name: systemBladeGeometry
    oid: 1.3.6.1.4.1.674.10892.5.1.3.17
    type: gauge
    help: This attribute defines the geometry for a modular system - 1.3.6.1.4.1.674.10892.5.1.3.17
    enum_values:
      1: other
      2: unknown
      3: singleWidthHalfHeight
      4: dualWidthHalfHeight
      5: singleWidthFullHeight
      6: dualWidthFullHeight
      7: singleWidthQuarterHeight
      8: u1HalfWidth
      9: u1QuarterWidth
      10: u1FullWidth
  - name: systemNodeID
    oid: 1.3.6.1.4.1.674.10892.5.1.3.18
    type: OctetString
    help: This attribute defines the node ID of the system - 1.3.6.1.4.1.674.10892.5.1.3.18
  - name: globalSystemStatus
    oid: 1.3.6.1.4.1.674.10892.5.2.1
    type: gauge
    help: This attribute defines the overall rollup status of all components in the
      system being monitored by the remote access card - 1.3.6.1.4.1.674.10892.5.2.1
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: systemLCDStatus
    oid: 1.3.6.1.4.1.674.10892.5.2.2
    type: gauge
    help: This attribute defines the system status as it is reflected by the LCD front
      panel - 1.3.6.1.4.1.674.10892.5.2.2
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: globalStorageStatus
    oid: 1.3.6.1.4.1.674.10892.5.2.3
    type: gauge
    help: This attribute defines the overall storage status being monitored by the
      remote access card. - 1.3.6.1.4.1.674.10892.5.2.3
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: systemPowerState
    oid: 1.3.6.1.4.1.674.10892.5.2.4
    type: gauge
    help: This attribute defines the power state of the system. - 1.3.6.1.4.1.674.10892.5.2.4
    enum_values:
      1: other
      2: unknown
      3: "off"
      4: "on"
  - name: systemPowerUpTime
    oid: 1.3.6.1.4.1.674.10892.5.2.5
    type: gauge
    help: This attribute defines the power-up time of the system in seconds. - 1.3.6.1.4.1.674.10892.5.2.5
  - name: processorDevicechassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.1
    type: gauge
    help: 1100.0030.0001.0001 This attribute defines the index (one based) of the
      associated system chassis. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.1
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.2
    type: gauge
    help: 1100.0030.0001.0002 This attribute defines the index (one based) of the
      processor device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.2
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.3
    type: gauge
    help: 1100.0030.0001.0003 This attribute defines the state capabilities of the
      processor device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.3
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: processorDeviceStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.4
    type: gauge
    help: 1100.0030.0001.0004 This attribute defines the state settings of the processor
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.4
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: processorDeviceStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.5
    type: gauge
    help: 1100.0030.0001.0005 This attribute defines the status of the processor device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.5
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: processorDeviceType
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.7
    type: gauge
    help: 1100.0030.0001.0007 This attribute defines the type of the processor device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.7
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
    enum_values:
      1: deviceTypeIsOther
      2: deviceTypeIsUnknown
      3: deviceTypeIsCPU
      4: deviceTypeIsMathProcessor
      5: deviceTypeIsDSP
      6: deviceTypeIsAVideoProcessor
  - name: processorDeviceManufacturerName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.8
    type: OctetString
    help: 1100.0030.0001.0008 This attribute defines the name of the manufacturer
      of the processor device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.8
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceStatusState
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.9
    type: gauge
    help: 1100.0030.0001.0009 This attribute defines the status state of the processor
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.9
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: enabled
      4: userDisabled
      5: biosDisabled
      6: idle
  - name: processorDeviceFamily
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.10
    type: gauge
    help: 1100.0030.0001.0010 This attribute defines the family of the processor device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.10
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
    enum_values:
      1: deviceFamilyIsOther
      2: deviceFamilyIsUnknown
      3: deviceFamilyIs8086
      4: deviceFamilyIs80286
      5: deviceFamilyIsIntel386
      6: deviceFamilyIsIntel486
      7: deviceFamilyIs8087
      8: deviceFamilyIs80287
      9: deviceFamilyIs80387
      10: deviceFamilyIs80487
      11: deviceFamilyIsPentium
      12: deviceFamilyIsPentiumPro
      13: deviceFamilyIsPentiumII
      14: deviceFamilyIsPentiumMMX
      15: deviceFamilyIsCeleron
      16: deviceFamilyIsPentiumIIXeon
      17: deviceFamilyIsPentiumIII
      18: deviceFamilyIsPentiumIIIXeon
      19: deviceFamilyIsPentiumIIISpeedStep
      20: deviceFamilyIsItanium
      21: deviceFamilyIsIntelXeon
      22: deviceFamilyIsPentium4
      23: deviceFamilyIsIntelXeonMP
      24: deviceFamilyIsIntelItanium2
      25: deviceFamilyIsK5
      26: deviceFamilyIsK6
      27: deviceFamilyIsK6Dash2
      28: deviceFamilyIsK6Dash3
      29: deviceFamilyIsAMDAthlon
      30: deviceFamilyIsAMD2900
      31: deviceFamilyIsK6Dash2Plus
      32: deviceFamilyIsPowerPC
      33: deviceFamilyIsPowerPC601
      34: deviceFamilyIsPowerPC603
      35: deviceFamilyIsPowerPC603Plus
      36: deviceFamilyIsPowerPC604
      37: deviceFamilyIsPowerPC620
      38: deviceFamilyIsPowerPCx704
      39: deviceFamilyIsPowerPC750
      40: deviceFamilyIsIntelCoreDuo
      41: deviceFamilyIsIntelCoreDuoMobile
      42: deviceFamilyIsIntelCoreSoloMobile
      43: deviceFamilyIsIntelAtom
      48: deviceFamilyIsAlpha
      49: deviceFamilyIsAlpha21064
      50: deviceFamilyIsAlpha21066
      51: deviceFamilyIsAlpha21164
      52: deviceFamilyIsAlpha21164PC
      53: deviceFamilyIsAlpha21164a
      54: deviceFamilyIsAlpha21264
      55: deviceFamilyIsAlpha21364
      56: deviceFamilyIsAMDTurionIIUltraDualMobileM
      57: deviceFamilyIsAMDTurionIIDualMobileM
      58: deviceFamilyIsAMDAthlonIIDualMobileM
      59: deviceFamilyIsAMDOpteron6100
      60: deviceFamilyIsAMDOpteron4100
      61: deviceFamilyIsAMDOpteron6200
      62: deviceFamilyIsAMDOpteron4200
      64: deviceFamilyIsMIPS
      65: deviceFamilyIsMIPSR4000
      66: deviceFamilyIsMIPSR4200
      67: deviceFamilyIsMIPSR4400
      68: deviceFamilyIsMIPSR4600
      69: deviceFamilyIsMIPSR10000
      80: deviceFamilyIsSPARC
      81: deviceFamilyIsSuperSPARC
      82: deviceFamilyIsmicroSPARCII
      83: deviceFamilyIsmicroSPARCIIep
      84: deviceFamilyIsUltraSPARC
      85: deviceFamilyIsUltraSPARCII
      86: deviceFamilyIsUltraSPARCIIi
      87: deviceFamilyIsUltraSPARCIII
      88: deviceFamilyIsUltraSPARCIIIi
      96: deviceFamilyIs68040
      97: deviceFamilyIs68xxx
      98: deviceFamilyIs68000
      99: deviceFamilyIs68010
      100: deviceFamilyIs68020
      101: deviceFamilyIs68030
      112: deviceFamilyIsHobbit
      120: deviceFamilyIsCrusoeTM5000
      121: deviceFamilyIsCrusoeTM3000
      122: deviceFamilyIsEfficeonTM8000
      128: deviceFamilyIsWeitek
      130: deviceFamilyIsIntelCeleronM
      131: deviceFamilyIsAMDAthlon64
      132: deviceFamilyIsAMDOpteron
      133: deviceFamilyIsAMDSempron
      134: deviceFamilyIsAMDTurion64Mobile
      135: deviceFamilyIsDualCoreAMDOpteron
      136: deviceFamilyIsAMDAthlon64X2DualCore
      137: deviceFamilyIsAMDTurion64X2Mobile
      138: deviceFamilyIsQuadCoreAMDOpteron
      139: deviceFamilyIsThirdGenerationAMDOpteron
      140: deviceFamilyIsAMDPhenomFXQuadCore
      141: deviceFamilyIsAMDPhenomX4QuadCore
      142: deviceFamilyIsAMDPhenomX2DualCore
      143: deviceFamilyIsAMDAthlonX2DualCore
      144: deviceFamilyIsPARISC
      145: deviceFamilyIsPARISC8500
      146: deviceFamilyIsPARISC8000
      147: deviceFamilyIsPARISC7300LC
      148: deviceFamilyIsPARISC7200
      149: deviceFamilyIsPARISC7100LC
      150: deviceFamilyIsPARISC7100
      160: deviceFamilyIsV30
      161: deviceFamilyIsQuadCoreIntelXeon3200
      162: deviceFamilyIsDualCoreIntelXeon3000
      163: deviceFamilyIsQuadCoreIntelXeon5300
      164: deviceFamilyIsDualCoreIntelXeon5100
      165: deviceFamilyIsDualCoreIntelXeon5000
      166: deviceFamilyIsDualCoreIntelXeonLV
      167: deviceFamilyIsDualCoreIntelXeonULV
      168: deviceFamilyIsDualCoreIntelXeon7100
      169: deviceFamilyIsQuadCoreIntelXeon5400
      170: deviceFamilyIsQuadCoreIntelXeon
      171: deviceFamilyIsDualCoreIntelXeon5200
      172: deviceFamilyIsDualCoreIntelXeon7200
      173: deviceFamilyIsQuadCoreIntelXeon7300
      174: deviceFamilyIsQuadCoreIntelXeon7400
      175: deviceFamilyIsMultiCoreIntelXeon7400
      176: deviceFamilyIsM1
      177: deviceFamilyIsM2
      179: deviceFamilyIsIntelPentium4HT
      180: deviceFamilyIsAS400
      182: deviceFamilyIsAMDAthlonXP
      183: deviceFamilyIsAMDAthlonMP
      184: deviceFamilyIsAMDDuron
      185: deviceFamilyIsIntelPentiumM
      186: deviceFamilyIsIntelCeleronD
      187: deviceFamilyIsIntelPentiumD
      188: deviceFamilyIsIntelPentiumExtreme
      189: deviceFamilyIsIntelCoreSolo
      190: deviceFamilyIsIntelCore2
      191: deviceFamilyIsIntelCore2Duo
      192: deviceFamilyIsIntelCore2Solo
      193: deviceFamilyIsIntelCore2Extreme
      194: deviceFamilyIsIntelCore2Quad
      195: deviceFamilyIsIntelCore2ExtremeMobile
      196: deviceFamilyIsIntelCore2DuoMobile
      197: deviceFamilyIsIntelCore2SoloMobile
      198: deviceFamilyIsIntelCorei7
      199: deviceFamilyIsDualCoreIntelCeleron
      200: deviceFamilyIsIBM390
      201: deviceFamilyIsG4
      202: deviceFamilyIsG5
      203: deviceFamilyIsESA390G6
      204: deviceFamilyIszArchitectur
      205: deviceFamilyIsIntelCorei5
      206: deviceFamilyIsIntelCorei3
      210: deviceFamilyIsVIAC7M
      211: deviceFamilyIsVIAC7D
      212: deviceFamilyIsVIAC7
      213: deviceFamilyIsVIAEden
      214: deviceFamilyIsMultiCoreIntelXeon
      215: deviceFamilyIsDualCoreIntelXeon3xxx
      216: deviceFamilyIsQuadCoreIntelXeon3xxx
      217: deviceFamilyIsVIANano
      218: deviceFamilyIsDualCoreIntelXeon5xxx
      219: deviceFamilyIsQuadCoreIntelXeon5xxx
      221: deviceFamilyIsDualCoreIntelXeon7xxx
      222: deviceFamilyIsQuadCoreIntelXeon7xxx
      223: deviceFamilyIsMultiCoreIntelXeon7xxx
      224: deviceFamilyIsMultiCoreIntelXeon3400
      230: deviceFamilyIsEmbeddedAMDOpertonQuadCore
      231: deviceFamilyIsAMDPhenomTripleCore
      232: deviceFamilyIsAMDTurionUltraDualCoreMobile
      233: deviceFamilyIsAMDTurionDualCoreMobile
      234: deviceFamilyIsAMDAthlonDualCore
      235: deviceFamilyIsAMDSempronSI
      236: deviceFamilyIsAMDPhenomII
      237: deviceFamilyIsAMDAthlonII
      238: deviceFamilyIsSixCoreAMDOpteron
      239: deviceFamilyIsAMDSempronM
      250: deviceFamilyIsi860
      251: deviceFamilyIsi960
  - name: processorDeviceMaximumSpeed
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.11
    type: gauge
    help: 1100.0030.0001.0011 This attribute defines the maximum speed of the processor
      device in MHz - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.11
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceCurrentSpeed
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.12
    type: gauge
    help: 1100.0030.0001.0012 This attribute defines the current speed of the processor
      device in MHz - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.12
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceExternalClockSpeed
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.13
    type: gauge
    help: 1100.0030.0001.0013 This attribute defines the speed of the external clock
      for the processor device in MHz - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.13
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceVoltage
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.14
    type: gauge
    help: 1100.0030.0001.0014 This attribute defines the voltage powering the processor
      device in millivolts - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.14
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceVersionName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.16
    type: OctetString
    help: 1100.0030.0001.0016 This attribute defines the version of the processor
      device - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.16
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceCoreCount
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.17
    type: gauge
    help: 1100.0030.0001.0017 This attribute defines the number of processor cores
      detected for the processor device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.17
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceCoreEnabledCount
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.18
    type: gauge
    help: 1100.0030.0001.0018 This attribute defines the number of processor cores
      enabled for the processor device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.18
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceThreadCount
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.19
    type: gauge
    help: 1100.0030.0001.0019 This attribute defines the number of processor threads
      detected for the processor device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.19
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceCharacteristics
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.20
    type: gauge
    help: 1100.0030.0001.0020 This attribute defines characteristics of the processor
      device - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.20
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceExtendedCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.21
    type: gauge
    help: 1100.0030.0001.0021 This attribute defines extended capabilities of the
      processor device - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.21
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceExtendedSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.22
    type: gauge
    help: 1100.0030.0001.0022 This attribute defines extended settings of the processor
      device - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.22
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceBrandName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.23
    type: OctetString
    help: 1100.0030.0001.0023 This attribute defines the brand of the processor device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.23
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceFQDD
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.30.1.26
    type: OctetString
    help: 1100.0030.0001.0026 Fully qualified device descriptor (FQDD) of the processor
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.30.1.26
    indexes:
    - labelname: processorDevicechassisIndex
      type: gauge
    - labelname: processorDeviceIndex
      type: gauge
  - name: processorDeviceStatusChassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.32.1.1
    type: gauge
    help: 1100.0032.0001.0001 This attribute defines the index (one based) of the
      associated system chassis. - 1.3.6.1.4.1.674.10892.5.4.1100.32.1.1
    indexes:
    - labelname: processorDeviceStatusChassisIndex
      type: gauge
    - labelname: processorDeviceStatusIndex
      type: gauge
  - name: processorDeviceStatusIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.32.1.2
    type: gauge
    help: 1100.0032.0001.0002 This attribute defines the index (one based) of the
      processor device status probe. - 1.3.6.1.4.1.674.10892.5.4.1100.32.1.2
    indexes:
    - labelname: processorDeviceStatusChassisIndex
      type: gauge
    - labelname: processorDeviceStatusIndex
      type: gauge
  - name: processorDeviceStatusStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.32.1.3
    type: gauge
    help: 1100.0032.0001.0003 This attribute defines the state capabilities of the
      processor device status probe. - 1.3.6.1.4.1.674.10892.5.4.1100.32.1.3
    indexes:
    - labelname: processorDeviceStatusChassisIndex
      type: gauge
    - labelname: processorDeviceStatusIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: processorDeviceStatusStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.32.1.4
    type: gauge
    help: 1100.0032.0001.0004 This attribute defines the state settings of the processor
      device status probe. - 1.3.6.1.4.1.674.10892.5.4.1100.32.1.4
    indexes:
    - labelname: processorDeviceStatusChassisIndex
      type: gauge
    - labelname: processorDeviceStatusIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: processorDeviceStatusStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.32.1.5
    type: gauge
    help: 1100.0032.0001.0005 This attribute defines the status of the processor device
      status probe - 1.3.6.1.4.1.674.10892.5.4.1100.32.1.5
    indexes:
    - labelname: processorDeviceStatusChassisIndex
      type: gauge
    - labelname: processorDeviceStatusIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: processorDeviceStatusReading
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.32.1.6
    type: gauge
    help: 1100.0032.0001.0006 This attribute defines the reading of the processor
      device status probe. - 1.3.6.1.4.1.674.10892.5.4.1100.32.1.6
    indexes:
    - labelname: processorDeviceStatusChassisIndex
      type: gauge
    - labelname: processorDeviceStatusIndex
      type: gauge
    enum_values:
      1: internalError
      2: thermalTrip
      32: configurationError
      128: processorPresent
      256: processorDisabled
      512: terminatorPresent
      1024: processorThrottled
  - name: processorDeviceStatusLocationName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.32.1.7
    type: OctetString
    help: 1100.0032.0001.0007 This attribute defines the location name of the processor
      device status probe. - 1.3.6.1.4.1.674.10892.5.4.1100.32.1.7
    indexes:
    - labelname: processorDeviceStatusChassisIndex
      type: gauge
    - labelname: processorDeviceStatusIndex
      type: gauge
  - name: memoryDevicechassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.1
    type: gauge
    help: 1100.0050.0001.0001 This attribute defines the index (one based) of the
      associated system chassis. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.1
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.2
    type: gauge
    help: 1100.0050.0001.0002 This attribute defines the index (one based) of the
      memory device. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.2
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.3
    type: gauge
    help: 1100.0050.0001.0003 This attribute defines the state capabilities of the
      memory device. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.3
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: memoryDeviceStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.4
    type: gauge
    help: 1100.0050.0001.0004 This attribute defines the state settings of the memory
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.4
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: memoryDeviceStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.5
    type: gauge
    help: 1100.0050.0001.0005 This attribute defines the status of the memory device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.5
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: memoryDeviceType
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.7
    type: EnumAsInfo
    help: 1100.0050.0001.0007 This attribute defines the type of the memory device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.7
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
    enum_values:
      1: deviceTypeIsOther
      2: deviceTypeIsUnknown
      3: deviceTypeIsDRAM
      4: deviceTypeIsEDRAM
      5: deviceTypeIsVRAM
      6: deviceTypeIsSRAM
      7: deviceTypeIsRAM
      8: deviceTypeIsROM
      9: deviceTypeIsFLASH
      10: deviceTypeIsEEPROM
      11: deviceTypeIsFEPROM
      12: deviceTypeIsEPROM
      13: deviceTypeIsCDRAM
      14: deviceTypeIs3DRAM
      15: deviceTypeIsSDRAM
      16: deviceTypeIsSGRAM
      17: deviceTypeIsRDRAM
      18: deviceTypeIsDDR
      19: deviceTypeIsDDR2
      20: deviceTypeIsDDR2FBDIMM
      24: deviceTypeIsDDR3
      25: deviceTypeIsFBD2
      26: deviceTypeIsDDR4
  - name: memoryDeviceLocationName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.8
    type: DisplayString
    help: 1100.0050.0001.0008 This attribute defines the location of the memory device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.8
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceBankLocationName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.10
    type: DisplayString
    help: 1100.0050.0001.0010 This attribute defines the location of the bank for
      the memory device. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.10
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceSize
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.14
    type: gauge
    help: 1100.0050.0001.0014 This attribute defines the size in KBytes of the memory
      device - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.14
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceSpeed
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.15
    type: gauge
    help: 1100.0050.0001.0015 This attribute defines the maximum capable speed in
      megahertz (MHz) of the memory device - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.15
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceManufacturerName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.21
    type: DisplayString
    help: 1100.0050.0001.0021 This attribute defines the manufacturer of the memory
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.21
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDevicePartNumberName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.22
    type: DisplayString
    help: 1100.0050.0001.0022 This attribute defines the manufacturer's part number
      for the memory device. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.22
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceSerialNumberName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.23
    type: DisplayString
    help: 1100.0050.0001.0023 This attribute defines the serial number of the memory
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.23
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceFQDD
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.26
    type: OctetString
    help: 1100.0050.0001.0026 Fully qualified device descriptor (FQDD) of the memory
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.26
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: memoryDeviceCurrentOperatingSpeed
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.50.1.27
    type: gauge
    help: 1100.0050.0001.0027 This attribute defines the current operating speed in
      megahertz (MHz) of the memory device - 1.3.6.1.4.1.674.10892.5.4.1100.50.1.27
    indexes:
    - labelname: memoryDevicechassisIndex
      type: gauge
    - labelname: memoryDeviceIndex
      type: gauge
  - name: pCIDevicechassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.1
    type: gauge
    help: 1100.0080.0001.0001 This attribute defines the index (one based) of the
      associated system chassis. - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.1
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
  - name: pCIDeviceIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.2
    type: gauge
    help: 1100.0080.0001.0002 This attribute defines the index (one based) of the
      PCI device. - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.2
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
  - name: pCIDeviceStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.3
    type: gauge
    help: 1100.0080.0001.0003 This attribute defines the state capabilities of the
      PCI device. - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.3
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: pCIDeviceStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.4
    type: gauge
    help: 1100.0080.0001.0004 This attribute defines the state settings of the PCI
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.4
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: pCIDeviceStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.5
    type: gauge
    help: 1100.0080.0001.0005 This attribute defines the status of the PCI device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.5
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: pCIDeviceDataBusWidth
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.7
    type: gauge
    help: 1100.0080.0001.0007 This attribute defines the width of the data bus of
      the PCI device - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.7
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
  - name: pCIDeviceManufacturerName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.8
    type: DisplayString
    help: 1100.0080.0001.0008 This attribute defines the name of the manufacturer
      of the PCI device. - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.8
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
  - name: pCIDeviceDescriptionName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.9
    type: DisplayString
    help: 1100.0080.0001.0009 This attribute defines the description of the PCI device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.9
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
  - name: pCIDeviceFQDD
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.80.1.12
    type: DisplayString
    help: 1100.0080.0001.0012 Fully qualified device descriptor (FQDD) of the PCI
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.80.1.12
    indexes:
    - labelname: pCIDevicechassisIndex
      type: gauge
    - labelname: pCIDeviceIndex
      type: gauge
  - name: networkDeviceChassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.1
    type: gauge
    help: 1100.0090.0001.0001 This attribute defines the index (one based) of the
      system chassis that contains the network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.1
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDeviceIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.2
    type: gauge
    help: 1100.0090.0001.0002 This attribute defines the index (one based) of the
      network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.2
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDeviceStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.3
    type: gauge
    help: 1100.0090.0001.0003 This attribute defines the status of the network device.
      - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.3
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: networkDeviceConnectionStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.4
    type: gauge
    help: 1100.0090.0001.0004 This attribute defines the connection status of the
      network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.4
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
    enum_values:
      1: connected
      2: disconnected
      3: driverBad
      4: driverDisabled
      10: hardwareInitalizing
      11: hardwareResetting
      12: hardwareClosing
      13: hardwareNotReady
  - name: networkDeviceProductName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.6
    type: DisplayString
    help: 1100.0090.0001.0006 This attribute defines the product name of the network
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.6
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDeviceVendorName
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.7
    type: DisplayString
    help: 1100.0090.0001.0007 This attribute defines the name of the vendor of the
      network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.7
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDeviceCurrentMACAddress
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.15
    type: OctetString
    help: 1100.0090.0001.0015 This attribute defines the current MAC address of the
      network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.15
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDevicePermanentMACAddress
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.16
    type: OctetString
    help: 1100.0090.0001.0016 This attribute defines the permanent MAC address of
      the network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.16
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDevicePCIBusNumber
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.17
    type: gauge
    help: 1100.0090.0001.0017 This attribute defines the PCI bus number of the network
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.17
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDevicePCIDeviceNumber
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.18
    type: gauge
    help: 1100.0090.0001.0018 This attribute defines the PCI device number of the
      network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.18
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDevicePCIFunctionNumber
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.19
    type: gauge
    help: 1100.0090.0001.0019 This attribute defines the PCI function number of the
      network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.19
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDeviceTOECapabilityFlags
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.23
    type: gauge
    help: 1100.0090.0001.0023 This attribute defines the TCP/IP Offload Engine (TOE)
      capability flags of the network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.23
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
    enum_values:
      1: unknown
      2: available
      4: notAvailable
      8: cannotBeDetermined
      16: driverNotResponding
  - name: networkDeviceiSCSICapabilityFlags
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.27
    type: gauge
    help: 1100.0090.0001.0027 This attribute defines the Internet Small Computer System
      Interface (iSCSI) capability flags of the network device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.27
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
    enum_values:
      1: unknown
      2: available
      4: notAvailable
      8: cannotBeDetermined
      16: driverNotResponding
  - name: networkDeviceiSCSIEnabled
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.28
    type: gauge
    help: 1100.0090.0001.0028 This attribute defines if iSCSI is enabled for the network
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.28
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: networkDeviceCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.29
    type: gauge
    help: 1100.0090.0001.0029 This attribute defines the capabilities of the network
      device - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.29
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
    enum_values:
      1: supported
      2: toe
      4: iscsiOffload
      8: fcoeOffload
  - name: networkDeviceFQDD
    oid: 1.3.6.1.4.1.674.10892.5.4.1100.90.1.30
    type: DisplayString
    help: 1100.0090.0001.0030 Fully qualified device descriptor (FQDD) of the network
      device. - 1.3.6.1.4.1.674.10892.5.4.1100.90.1.30
    indexes:
    - labelname: networkDeviceChassisIndex
      type: gauge
    - labelname: networkDeviceIndex
      type: gauge
  - name: fruChassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.2000.10.1.1
    type: gauge
    help: 2000.0010.0001.0001 This attribute defines the index (one based) of the
      system chassis containing the field replaceable unit. - 1.3.6.1.4.1.674.10892.5.4.2000.10.1.1
    indexes:
    - labelname: fruChassisIndex
      type: gauge
    - labelname: fruIndex
      type: gauge
  - name: fruIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.2000.10.1.2
    type: gauge
    help: 2000.0010.0001.0002 This attribute defines the index (one based) of the
      field replaceable unit. - 1.3.6.1.4.1.674.10892.5.4.2000.10.1.2
    indexes:
    - labelname: fruChassisIndex
      type: gauge
    - labelname: fruIndex
      type: gauge
  - name: fruInformationStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.2000.10.1.3
    type: gauge
    help: 2000.0010.0001.0003 This attribute defines the status of the field replaceable
      unit information. - 1.3.6.1.4.1.674.10892.5.4.2000.10.1.3
    indexes:
    - labelname: fruChassisIndex
      type: gauge
    - labelname: fruIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: fruManufacturerName
    oid: 1.3.6.1.4.1.674.10892.5.4.2000.10.1.6
    type: DisplayString
    help: 2000.0010.0001.0006 This attribute defines the manufacturer of the field
      replaceable unit. - 1.3.6.1.4.1.674.10892.5.4.2000.10.1.6
    indexes:
    - labelname: fruChassisIndex
      type: gauge
    - labelname: fruIndex
      type: gauge
  - name: fruSerialNumberName
    oid: 1.3.6.1.4.1.674.10892.5.4.2000.10.1.7
    type: DisplayString
    help: 2000.0010.0001.0007 This attribute defines the serial number of the field
      replaceable unit. - 1.3.6.1.4.1.674.10892.5.4.2000.10.1.7
    indexes:
    - labelname: fruChassisIndex
      type: gauge
    - labelname: fruIndex
      type: gauge
  - name: fruPartNumberName
    oid: 1.3.6.1.4.1.674.10892.5.4.2000.10.1.8
    type: DisplayString
    help: 2000.0010.0001.0008 This attribute defines the part number of the field
      replaceable unit. - 1.3.6.1.4.1.674.10892.5.4.2000.10.1.8
    indexes:
    - labelname: fruChassisIndex
      type: gauge
    - labelname: fruIndex
      type: gauge
  - name: fruRevisionName
    oid: 1.3.6.1.4.1.674.10892.5.4.2000.10.1.9
    type: DisplayString
    help: 2000.0010.0001.0009 This attribute defines the revision of the field replaceable
      unit. - 1.3.6.1.4.1.674.10892.5.4.2000.10.1.9
    indexes:
    - labelname: fruChassisIndex
      type: gauge
    - labelname: fruIndex
      type: gauge
  - name: fruFQDD
    oid: 1.3.6.1.4.1.674.10892.5.4.2000.10.1.12
    type: DisplayString
    help: 2000.0010.0001.0012 Fully qualified device descriptor (FQDD) of the field
      replaceable unit. - 1.3.6.1.4.1.674.10892.5.4.2000.10.1.12
    indexes:
    - labelname: fruChassisIndex
      type: gauge
    - labelname: fruIndex
      type: gauge
  - name: numEventLogEntries
    oid: 1.3.6.1.4.1.674.10892.5.4.300.1
    type: gauge
    help: 0300.0001.0000 This attribute provides the number of entries currently in
      the eventLogTable. - 1.3.6.1.4.1.674.10892.5.4.300.1
  - name: systemBIOSchassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.300.50.1.1
    type: gauge
    help: 0300.0050.0001.0001 This attribute defines the index (one based) of the
      associated system chassis. - 1.3.6.1.4.1.674.10892.5.4.300.50.1.1
    indexes:
    - labelname: systemBIOSchassisIndex
      type: gauge
    - labelname: systemBIOSIndex
      type: gauge
  - name: systemBIOSIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.300.50.1.2
    type: gauge
    help: 0300.0050.0001.0002 This attribute defines the index (one based) of the
      system BIOS. - 1.3.6.1.4.1.674.10892.5.4.300.50.1.2
    indexes:
    - labelname: systemBIOSchassisIndex
      type: gauge
    - labelname: systemBIOSIndex
      type: gauge
  - name: systemBIOSStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.300.50.1.3
    type: gauge
    help: 0300.0050.0001.0003 This attribute defines the state capabilities of the
      system BIOS. - 1.3.6.1.4.1.674.10892.5.4.300.50.1.3
    indexes:
    - labelname: systemBIOSchassisIndex
      type: gauge
    - labelname: systemBIOSIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: systemBIOSStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.300.50.1.4
    type: gauge
    help: 0300.0050.0001.0004 This attribute defines the state settings of the system
      BIOS. - 1.3.6.1.4.1.674.10892.5.4.300.50.1.4
    indexes:
    - labelname: systemBIOSchassisIndex
      type: gauge
    - labelname: systemBIOSIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: systemBIOSStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.300.50.1.5
    type: gauge
    help: 0300.0050.0001.0005 This attribute defines the status of the system BIOS.
      - 1.3.6.1.4.1.674.10892.5.4.300.50.1.5
    indexes:
    - labelname: systemBIOSchassisIndex
      type: gauge
    - labelname: systemBIOSIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: systemBIOSReleaseDateName
    oid: 1.3.6.1.4.1.674.10892.5.4.300.50.1.7
    type: OctetString
    help: 0300.0050.0001.0007 This attribute defines the release date name of the
      system BIOS. - 1.3.6.1.4.1.674.10892.5.4.300.50.1.7
    indexes:
    - labelname: systemBIOSchassisIndex
      type: gauge
    - labelname: systemBIOSIndex
      type: gauge
  - name: systemBIOSVersionName
    oid: 1.3.6.1.4.1.674.10892.5.4.300.50.1.8
    type: DisplayString
    help: 0300.0050.0001.0008 This attribute defines the version name of the system
      BIOS. - 1.3.6.1.4.1.674.10892.5.4.300.50.1.8
    indexes:
    - labelname: systemBIOSchassisIndex
      type: gauge
    - labelname: systemBIOSIndex
      type: gauge
  - name: systemBIOSManufacturerName
    oid: 1.3.6.1.4.1.674.10892.5.4.300.50.1.11
    type: DisplayString
    help: 0300.0050.0001.0011 This attribute defines the name of the manufacturer
      of the system BIOS. - 1.3.6.1.4.1.674.10892.5.4.300.50.1.11
    indexes:
    - labelname: systemBIOSchassisIndex
      type: gauge
    - labelname: systemBIOSIndex
      type: gauge
  - name: firmwarechassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.1
    type: gauge
    help: 0300.0060.0001.0001 This attribute defines the index (one based) of the
      associated system chassis. - 1.3.6.1.4.1.674.10892.5.4.300.60.1.1
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
  - name: firmwareIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.2
    type: gauge
    help: 0300.0060.0001.0002 This attribute defines the index (one based) of the
      firmware. - 1.3.6.1.4.1.674.10892.5.4.300.60.1.2
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
  - name: firmwareStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.3
    type: gauge
    help: 0300.0060.0001.0003 This attribute defines the state capabilities of the
      firmware. - 1.3.6.1.4.1.674.10892.5.4.300.60.1.3
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: firmwareStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.4
    type: gauge
    help: 0300.0060.0001.0004 This attribute defines the state settings of the firmware.
      - 1.3.6.1.4.1.674.10892.5.4.300.60.1.4
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: firmwareStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.5
    type: gauge
    help: 0300.0060.0001.0005 This attribute defines the status of the firmware. -
      1.3.6.1.4.1.674.10892.5.4.300.60.1.5
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: firmwareSize
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.6
    type: gauge
    help: 0300.0060.0001.0006 This attribute defines the image size of the firmware
      in KBytes - 1.3.6.1.4.1.674.10892.5.4.300.60.1.6
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
  - name: firmwareType
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.7
    type: gauge
    help: 0300.0060.0001.0007 This attribute defines the type of firmware. - 1.3.6.1.4.1.674.10892.5.4.300.60.1.7
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      20: lifecycleController
      21: iDRAC7
      22: iDRAC8
  - name: firmwareTypeName
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.8
    type: DisplayString
    help: 0300.0060.0001.0008 This attribute defines the type name of the firmware.
      - 1.3.6.1.4.1.674.10892.5.4.300.60.1.8
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
  - name: firmwareUpdateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.9
    type: gauge
    help: 0300.0060.0001.0009 This attribute defines the bitmap of supported methods
      for firmware update. - 1.3.6.1.4.1.674.10892.5.4.300.60.1.9
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
  - name: firmwareVersionName
    oid: 1.3.6.1.4.1.674.10892.5.4.300.60.1.11
    type: DisplayString
    help: 0300.0060.0001.0011 This attribute defines the version of the firmware.
      - 1.3.6.1.4.1.674.10892.5.4.300.60.1.11
    indexes:
    - labelname: firmwarechassisIndex
      type: gauge
    - labelname: firmwareIndex
      type: gauge
  - name: intrusionchassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.300.70.1.1
    type: gauge
    help: 0300.0070.0001.0001 This attribute defines the index (one based) of the
      associated system chassis. - 1.3.6.1.4.1.674.10892.5.4.300.70.1.1
    indexes:
    - labelname: intrusionchassisIndex
      type: gauge
    - labelname: intrusionIndex
      type: gauge
  - name: intrusionIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.300.70.1.2
    type: gauge
    help: 0300.0070.0001.0002 This attribute defines the index (one based) of the
      intrusion sensor. - 1.3.6.1.4.1.674.10892.5.4.300.70.1.2
    indexes:
    - labelname: intrusionchassisIndex
      type: gauge
    - labelname: intrusionIndex
      type: gauge
  - name: intrusionStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.300.70.1.3
    type: gauge
    help: 0300.0070.0001.0003 This attribute defines the state capabilities of the
      intrusion sensor. - 1.3.6.1.4.1.674.10892.5.4.300.70.1.3
    indexes:
    - labelname: intrusionchassisIndex
      type: gauge
    - labelname: intrusionIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: intrusionStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.300.70.1.4
    type: gauge
    help: 0300.0070.0001.0004 This attribute defines the state settings of the intrusion
      sensor. - 1.3.6.1.4.1.674.10892.5.4.300.70.1.4
    indexes:
    - labelname: intrusionchassisIndex
      type: gauge
    - labelname: intrusionIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: intrusionStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.300.70.1.5
    type: gauge
    help: 0300.0070.0001.0005 This attribute defines the status of the intrusion sensor.
      - 1.3.6.1.4.1.674.10892.5.4.300.70.1.5
    indexes:
    - labelname: intrusionchassisIndex
      type: gauge
    - labelname: intrusionIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: intrusionReading
    oid: 1.3.6.1.4.1.674.10892.5.4.300.70.1.6
    type: gauge
    help: 0300.0070.0001.0006 This attribute defines the reading of the intrusion
      sensor. - 1.3.6.1.4.1.674.10892.5.4.300.70.1.6
    indexes:
    - labelname: intrusionchassisIndex
      type: gauge
    - labelname: intrusionIndex
      type: gauge
    enum_values:
      1: chassisNotBreached
      2: chassisBreached
      3: chassisBreachedPrior
      4: chassisBreachSensorFailure
  - name: intrusionType
    oid: 1.3.6.1.4.1.674.10892.5.4.300.70.1.7
    type: gauge
    help: 0300.0070.0001.0007 This attribute defines the type of the intrusion sensor.
      - 1.3.6.1.4.1.674.10892.5.4.300.70.1.7
    indexes:
    - labelname: intrusionchassisIndex
      type: gauge
    - labelname: intrusionIndex
      type: gauge
    enum_values:
      1: chassisBreachDetectionWhenPowerON
      2: chassisBreachDetectionWhenPowerOFF
  - name: intrusionLocationName
    oid: 1.3.6.1.4.1.674.10892.5.4.300.70.1.8
    type: DisplayString
    help: 0300.0070.0001.0008 This attribute defines the location of the intrusion
      sensor. - 1.3.6.1.4.1.674.10892.5.4.300.70.1.8
    indexes:
    - labelname: intrusionchassisIndex
      type: gauge
    - labelname: intrusionIndex
      type: gauge
  - name: powerSupplychassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.1
    type: gauge
    help: 0600.0012.0001.0001 This attribute defines the index (one based) of the
      system chassis. - 1.3.6.1.4.1.674.10892.5.4.600.12.1.1
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplyIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.2
    type: gauge
    help: 0600.0012.0001.0002 This attribute defines the index (one based) of the
      power supply. - 1.3.6.1.4.1.674.10892.5.4.600.12.1.2
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplyStateCapabilitiesUnique
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.3
    type: gauge
    help: 0600.0012.0001.0003 This attribute defines the state capabilities of the
      power supply. - 1.3.6.1.4.1.674.10892.5.4.600.12.1.3
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
    enum_values:
      1: unknown
      2: onlineCapable
      4: notReadyCapable
  - name: powerSupplyStateSettingsUnique
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.4
    type: gauge
    help: 0600.0012.0001.0004 This attribute defines the state settings of the power
      supply. - 1.3.6.1.4.1.674.10892.5.4.600.12.1.4
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
    enum_values:
      1: unknown
      2: onLine
      4: notReady
      8: fanFailure
      10: onlineAndFanFailure
      16: powerSupplyIsON
      32: powerSupplyIsOK
      64: acSwitchIsON
      66: onlineandAcSwitchIsON
      128: acPowerIsON
      130: onlineAndAcPowerIsON
      210: onlineAndPredictiveFailure
      242: acPowerAndSwitchAreOnPowerSupplyIsOnIsOkAndOnline
  - name: powerSupplyStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.5
    type: gauge
    help: 0600.0012.0001.0005 This attribute defines the status of the power supply.
      - 1.3.6.1.4.1.674.10892.5.4.600.12.1.5
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: powerSupplyOutputWatts
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.6
    type: gauge
    help: 0600.0012.0001.0006 This attribute defines the maximum sustained output
      wattage of the power supply (in tenths of Watts). - 1.3.6.1.4.1.674.10892.5.4.600.12.1.6
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplyType
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.7
    type: gauge
    help: 0600.0012.0001.0007 This attribute defines the type of the power supply.
      - 1.3.6.1.4.1.674.10892.5.4.600.12.1.7
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
    enum_values:
      1: powerSupplyTypeIsOther
      2: powerSupplyTypeIsUnknown
      3: powerSupplyTypeIsLinear
      4: powerSupplyTypeIsSwitching
      5: powerSupplyTypeIsBattery
      6: powerSupplyTypeIsUPS
      7: powerSupplyTypeIsConverter
      8: powerSupplyTypeIsRegulator
      9: powerSupplyTypeIsAC
      10: powerSupplyTypeIsDC
      11: powerSupplyTypeIsVRM
  - name: powerSupplyLocationName
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.8
    type: DisplayString
    help: 0600.0012.0001.0008 This attribute defines the location of the power supply.
      - 1.3.6.1.4.1.674.10892.5.4.600.12.1.8
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplyMaximumInputVoltage
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.9
    type: gauge
    help: 0600.0012.0001.0009 This attribute defines the maximum input voltage of
      the power supply (in Volts). - 1.3.6.1.4.1.674.10892.5.4.600.12.1.9
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplypowerUnitIndexReference
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.10
    type: gauge
    help: 0600.0012.0001.0010 This attribute defines the index to the associated power
      unit if the power supply is part of a power unit. - 1.3.6.1.4.1.674.10892.5.4.600.12.1.10
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplySensorState
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.11
    type: gauge
    help: 0600.0012.0001.0011 This attribute defines the state reported by the power
      supply sensor - 1.3.6.1.4.1.674.10892.5.4.600.12.1.11
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
    enum_values:
      1: presenceDetected
      2: psFailureDetected
      4: predictiveFailure
      8: psACLost
      16: acLostOrOutOfRange
      32: acOutOfRangeButPresent
      64: configurationError
  - name: powerSupplyConfigurationErrorType
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.12
    type: gauge
    help: 0600.0012.0001.0012 This attribute defines the type of configuration error
      reported by the power supply sensor - 1.3.6.1.4.1.674.10892.5.4.600.12.1.12
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
    enum_values:
      1: vendorMismatch
      2: revisionMismatch
      3: processorMissing
  - name: powerSupplyPowerMonitorCapable
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.13
    type: gauge
    help: 0600.0012.0001.0013 This attribute defines a boolean value that reports
      whether the power supply is capable of monitoring power consumption. - 1.3.6.1.4.1.674.10892.5.4.600.12.1.13
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplyRatedInputWattage
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.14
    type: gauge
    help: 0600.0012.0001.0014 This attribute defines the rated input wattage of the
      power supply (in tenths of Watts). - 1.3.6.1.4.1.674.10892.5.4.600.12.1.14
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplyFQDD
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.15
    type: OctetString
    help: 0600.0012.0001.0015 Fully qualified device descriptor (FQDD) of the power
      supply. - 1.3.6.1.4.1.674.10892.5.4.600.12.1.15
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: powerSupplyCurrentInputVoltage
    oid: 1.3.6.1.4.1.674.10892.5.4.600.12.1.16
    type: gauge
    help: 0600.0012.0001.0016 This attribute defines the current input voltage to
      the power supply (in Volts). - 1.3.6.1.4.1.674.10892.5.4.600.12.1.16
    indexes:
    - labelname: powerSupplychassisIndex
      type: gauge
    - labelname: powerSupplyIndex
      type: gauge
  - name: systemBatteryChassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.600.50.1.1
    type: gauge
    help: 0600.0050.0001.0001 This attribute defines the index (one based) of the
      system chassis that contains the battery. - 1.3.6.1.4.1.674.10892.5.4.600.50.1.1
    indexes:
    - labelname: systemBatteryChassisIndex
      type: gauge
    - labelname: systemBatteryIndex
      type: gauge
  - name: systemBatteryIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.600.50.1.2
    type: gauge
    help: 0600.0050.0001.0002 This attribute defines the index (one based) of the
      battery. - 1.3.6.1.4.1.674.10892.5.4.600.50.1.2
    indexes:
    - labelname: systemBatteryChassisIndex
      type: gauge
    - labelname: systemBatteryIndex
      type: gauge
  - name: systemBatteryStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.600.50.1.3
    type: gauge
    help: 0600.0050.0001.0003 This attribute defines the state capabilities of the
      battery. - 1.3.6.1.4.1.674.10892.5.4.600.50.1.3
    indexes:
    - labelname: systemBatteryChassisIndex
      type: gauge
    - labelname: systemBatteryIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: systemBatteryStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.600.50.1.4
    type: gauge
    help: 0600.0050.0001.0004 This attribute defines the state settings of the battery.
      - 1.3.6.1.4.1.674.10892.5.4.600.50.1.4
    indexes:
    - labelname: systemBatteryChassisIndex
      type: gauge
    - labelname: systemBatteryIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: systemBatteryStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.600.50.1.5
    type: gauge
    help: 0600.0050.0001.0005 This attribute defines the status of the battery. -
      1.3.6.1.4.1.674.10892.5.4.600.50.1.5
    indexes:
    - labelname: systemBatteryChassisIndex
      type: gauge
    - labelname: systemBatteryIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: systemBatteryReading
    oid: 1.3.6.1.4.1.674.10892.5.4.600.50.1.6
    type: gauge
    help: 0600.0050.0001.0006 This attribute defines the reading of the battery. -
      1.3.6.1.4.1.674.10892.5.4.600.50.1.6
    indexes:
    - labelname: systemBatteryChassisIndex
      type: gauge
    - labelname: systemBatteryIndex
      type: gauge
    enum_values:
      1: predictiveFailure
      2: failed
      4: presenceDetected
  - name: systemBatteryLocationName
    oid: 1.3.6.1.4.1.674.10892.5.4.600.50.1.7
    type: DisplayString
    help: 0600.0050.0001.0007 This attribute defines the location of the battery.
      - 1.3.6.1.4.1.674.10892.5.4.600.50.1.7
    indexes:
    - labelname: systemBatteryChassisIndex
      type: gauge
    - labelname: systemBatteryIndex
      type: gauge
  - name: coolingDeviceStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.700.12.1.5
    type: gauge
    help: 0700.0012.0001.0005 This attribute defines the probe status of the cooling
      device. - 1.3.6.1.4.1.674.10892.5.4.700.12.1.5
    indexes:
    - labelname: coolingDevicechassisIndex
      type: gauge
    - labelname: coolingDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCriticalUpper
      5: criticalUpper
      6: nonRecoverableUpper
      7: nonCriticalLower
      8: criticalLower
      9: nonRecoverableLower
      10: failed
  - name: coolingDeviceLocationName
    oid: 1.3.6.1.4.1.674.10892.5.4.700.12.1.8
    type: DisplayString
    help: 0700.0012.0001.0008 This attribute defines the location name of the cooling
      device. - 1.3.6.1.4.1.674.10892.5.4.700.12.1.8
    indexes:
    - labelname: coolingDevicechassisIndex
      type: gauge
    - labelname: coolingDeviceIndex
      type: gauge
  - name: temperatureProbechassisIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.1
    type: gauge
    help: 0700.0020.0001.0001 This attribute defines the index (one based) of the
      associated system chassis. - 1.3.6.1.4.1.674.10892.5.4.700.20.1.1
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeIndex
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.2
    type: gauge
    help: 0700.0020.0001.0002 This attribute defines the index (one based) of the
      temperature probe. - 1.3.6.1.4.1.674.10892.5.4.700.20.1.2
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeStateCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.3
    type: gauge
    help: 0700.0020.0001.0003 This attribute defines the state capabilities of the
      temperature probe. - 1.3.6.1.4.1.674.10892.5.4.700.20.1.3
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
    enum_values:
      1: unknownCapabilities
      2: enableCapable
      4: notReadyCapable
      6: enableAndNotReadyCapable
  - name: temperatureProbeStateSettings
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.4
    type: gauge
    help: 0700.0020.0001.0004 This attribute defines the state settings of the temperature
      probe. - 1.3.6.1.4.1.674.10892.5.4.700.20.1.4
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      4: notReady
      6: enabledAndNotReady
  - name: temperatureProbeStatus
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.5
    type: gauge
    help: 0700.0020.0001.0005 This attribute defines the probe status of the temperature
      probe. - 1.3.6.1.4.1.674.10892.5.4.700.20.1.5
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCriticalUpper
      5: criticalUpper
      6: nonRecoverableUpper
      7: nonCriticalLower
      8: criticalLower
      9: nonRecoverableLower
      10: failed
  - name: temperatureProbeReading
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.6
    type: gauge
    help: 0700.0020.0001.0006 This attribute defines the reading for a temperature
      probe of type other than temperatureProbeTypeIsDiscrete - 1.3.6.1.4.1.674.10892.5.4.700.20.1.6
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeType
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.7
    type: gauge
    help: 0700.0020.0001.0007 This attribute defines the type of the temperature probe.
      - 1.3.6.1.4.1.674.10892.5.4.700.20.1.7
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
    enum_values:
      1: temperatureProbeTypeIsOther
      2: temperatureProbeTypeIsUnknown
      3: temperatureProbeTypeIsAmbientESM
      16: temperatureProbeTypeIsDiscrete
  - name: temperatureProbeLocationName
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.8
    type: DisplayString
    help: 0700.0020.0001.0008 This attribute defines the location name of the temperature
      probe. - 1.3.6.1.4.1.674.10892.5.4.700.20.1.8
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeUpperNonRecoverableThreshold
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.9
    type: gauge
    help: 0700.0020.0001.0009 This attribute defines the upper nonrecoverable threshold
      of the temperature probe - 1.3.6.1.4.1.674.10892.5.4.700.20.1.9
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeUpperCriticalThreshold
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.10
    type: gauge
    help: 0700.0020.0001.0010 This attribute defines the upper critical threshold
      of the temperature probe - 1.3.6.1.4.1.674.10892.5.4.700.20.1.10
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeUpperNonCriticalThreshold
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.11
    type: gauge
    help: 0700.0020.0001.0011 This attribute defines the upper noncritical threshold
      of the temperature probe - 1.3.6.1.4.1.674.10892.5.4.700.20.1.11
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeLowerNonCriticalThreshold
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.12
    type: gauge
    help: 0700.0020.0001.0012 This attribute defines the lower noncritical threshold
      of the temperature probe - 1.3.6.1.4.1.674.10892.5.4.700.20.1.12
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeLowerCriticalThreshold
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.13
    type: gauge
    help: 0700.0020.0001.0013 This attribute defines the lower critical threshold
      of the temperature probe - 1.3.6.1.4.1.674.10892.5.4.700.20.1.13
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeLowerNonRecoverableThreshold
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.14
    type: gauge
    help: 0700.0020.0001.0014 This attribute defines the lower nonrecoverable threshold
      of the temperature probe - 1.3.6.1.4.1.674.10892.5.4.700.20.1.14
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
  - name: temperatureProbeProbeCapabilities
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.15
    type: gauge
    help: 0700.0020.0001.0015 This attribute defines the probe capabilities of the
      temperature probe. - 1.3.6.1.4.1.674.10892.5.4.700.20.1.15
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
    enum_values:
      1: upperNonCriticalThresholdSetCapable
      2: lowerNonCriticalThresholdSetCapable
      4: upperNonCriticalThresholdDefaultCapable
      8: lowerNonCriticalThresholdDefaultCapable
  - name: temperatureProbeDiscreteReading
    oid: 1.3.6.1.4.1.674.10892.5.4.700.20.1.16
    type: gauge
    help: 0700.0020.0001.0016 This attribute defines the reading for a temperature
      probe of type temperatureProbeTypeIsDiscrete - 1.3.6.1.4.1.674.10892.5.4.700.20.1.16
    indexes:
    - labelname: temperatureProbechassisIndex
      type: gauge
    - labelname: temperatureProbeIndex
      type: gauge
    enum_values:
      1: temperatureIsGood
      2: temperatureIsBad
  - name: controllerNumber
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.1
    type: gauge
    help: Instance number of this controller entry. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.1
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerName
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.2
    type: DisplayString
    help: The controller's name as represented in Storage Management. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.2
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerRebuildRate
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.7
    type: gauge
    help: The rebuild rate is the percentage of the controller's resources dedicated
      to rebuilding a failed disk when a rebuild is necessary. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.7
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerFWVersion
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.8
    type: DisplayString
    help: The controller's current firmware version. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.8
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerCacheSizeInMB
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.9
    type: gauge
    help: The controller's current amount of cache memory in megabytes. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.9
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerRollUpStatus
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.37
    type: gauge
    help: Severity of the controller state - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.37
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: controllerComponentStatus
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.38
    type: gauge
    help: The status of the controller itself without the propagation of any contained
      component status - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.38
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: controllerDriverVersion
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.41
    type: DisplayString
    help: Currently installed driver version for this controller on the host. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.41
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerPCISlot
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.42
    type: DisplayString
    help: The PCI slot on the server where the controller is seated - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.42
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerReconstructRate
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.48
    type: gauge
    help: The reconstruct rate is the percentage of the controller's resources dedicated
      to reconstructing a disk group after adding a physical disk or changing the
      RAID level of a virtual disk residing on the disk group. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.48
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerPatrolReadRate
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.49
    type: gauge
    help: The patrol read rate is the percentage of the controller's resources dedicated
      to perform a patrol read on disks participating in a virtual disk or hot spares.
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.49
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerBGIRate
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.50
    type: gauge
    help: The background initialization (BGI) rate is the percentage of the controller's
      resources dedicated to performing the background initialization of a redundant
      virtual disk after it is created. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.50
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerCheckConsistencyRate
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.51
    type: gauge
    help: The check consistency rate is the percentage of the controller's resources
      dedicated to performing a check consistency on a redundant virtual disk. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.51
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerPatrolReadMode
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.52
    type: gauge
    help: Identifies the patrol read mode setting for the controller - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.52
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: disabled
      4: auto
      5: manual
  - name: controllerPatrolReadState
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.53
    type: gauge
    help: This property displays the current state of the patrol read process - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.53
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: stopped
      3: active
  - name: controllerPersistentHotSpare
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.59
    type: gauge
    help: Indicates whether hot spare drives would be restored on insertion into the
      same slot. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.59
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerSpinDownUnconfiguredDrives
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.60
    type: gauge
    help: Indicates whether un-configured drives would be put in power save mode by
      the controller. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.60
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerSpinDownHotSpareDrives
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.61
    type: gauge
    help: Indicates whether hot spare drives would be put in power save mode by the
      controller. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.61
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerSpinDownTimeInterval
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.62
    type: gauge
    help: The duration in minutes after which, the unconfigured or hot spare drives
      will be spun down to power save mode. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.62
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerPreservedCache
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.69
    type: gauge
    help: Indicates whether preserved cache or pinned cache is present on the controller.
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.69
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerCheckConsistencyMode
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.70
    type: gauge
    help: The current check consistency mode setting for the controller - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.70
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: unsupported
      3: normal
      4: stopOnError
  - name: controllerCopyBackMode
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.71
    type: gauge
    help: The current copy back mode setting for the controller - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.71
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: unsupported
      3: "on"
      4: onWithSmart
      5: "off"
  - name: controllerSecurityStatus
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.72
    type: gauge
    help: The controller's current security/encryption status. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.72
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: unknown
      2: none
      3: lkm
  - name: controllerEncryptionKeyPresent
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.73
    type: gauge
    help: Indicates whether encryption key is assigned for the controller. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.73
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerEncryptionCapability
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.74
    type: gauge
    help: The type of encryption supported by the controller - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.74
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: none
      3: lkm
  - name: controllerLoadBalanceSetting
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.75
    type: gauge
    help: The ability of the controller to automatically use both controller ports
      (or connectors) connected to the same enclosure in order to route I/O requests
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.75
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: unsupported
      3: auto
      4: none
  - name: controllerMaxCapSpeed
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.76
    type: gauge
    help: The maximum speed of the controller.in Gigbits per second (Gbps) - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.76
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: unknown
      2: oneDotFiveGbps
      3: threeGbps
      4: sixGbps
      5: twelveGbps
  - name: controllerSASAddress
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.77
    type: DisplayString
    help: The SAS address of the controller. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.77
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerFQDD
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.78
    type: OctetString
    help: The controller's Fully Qualified Device Descriptor (FQDD) as represented
      in Storage Management. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.78
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerDisplayName
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.79
    type: DisplayString
    help: The controller's friendly FQDD as represented in Storage Management. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.79
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerT10PICapability
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.80
    type: gauge
    help: Indicates whether the controller supports the T10 PI (Protection Information)
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.80
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: capable
      3: notCapable
  - name: controllerRAID10UnevenSpansSupported
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.81
    type: gauge
    help: Indicates whether uneven spans for RAID 10 virtual disk is supported on
      the controller. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.81
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerEnhancedAutoImportForeignConfigMode
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.82
    type: gauge
    help: Indicates the status of enhanced auto-import of foreign configuration property
      of the controller - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.82
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: disabled
      4: enabled
  - name: controllerBootModeSupported
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.83
    type: gauge
    help: Indicates whether headless boot mode settings are supported on the controller.
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.83
    indexes:
    - labelname: controllerNumber
      type: gauge
  - name: controllerBootMode
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.84
    type: gauge
    help: Indicates the boot mode of the controller - 1.3.6.1.4.1.674.10892.5.5.1.20.130.1.1.84
    indexes:
    - labelname: controllerNumber
      type: gauge
    enum_values:
      1: notApplicable
      2: user
      3: contOnError
      4: headlessContOnError
      5: headlessSafe
  - name: physicalDiskNumber
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.1
    type: gauge
    help: Instance number of this physical disk entry. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.1
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskName
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.2
    type: DisplayString
    help: The physical disk's name as represented in Storage Management. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.2
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskManufacturer
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.3
    type: DisplayString
    help: The name of the physical disk's manufacturer. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.3
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskState
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.4
    type: gauge
    help: The current state of this physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.4
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: unknown
      2: ready
      3: online
      4: foreign
      5: offline
      6: blocked
      7: failed
      8: nonraid
      9: removed
      10: readonly
  - name: physicalDiskProductID
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.6
    type: DisplayString
    help: The model number of the physical disk. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.6
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskSerialNo
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.7
    type: DisplayString
    help: The physical disk's unique identification number from the manufacturer.
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.7
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskRevision
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.8
    type: DisplayString
    help: The firmware version of the physical disk. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.8
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskCapacityInMB
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.11
    type: gauge
    help: The size of the physical disk in megabytes. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.11
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskUsedSpaceInMB
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.17
    type: gauge
    help: The amount of used space in megabytes on the physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.17
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskFreeSpaceInMB
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.19
    type: gauge
    help: The amount of free space in megabytes on the physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.19
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskBusType
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.21
    type: gauge
    help: The bus type of the physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.21
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: unknown
      2: scsi
      3: sas
      4: sata
      5: fibre
      6: pcie
  - name: physicalDiskSpareState
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.22
    type: gauge
    help: The status of the disk as a spare - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.22
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: notASpare
      2: dedicatedHotSpare
      3: globalHotSpare
  - name: physicalDiskComponentStatus
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.24
    type: gauge
    help: The status of the physical disk itself without the propagation of any contained
      component status - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.24
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: physicalDiskPartNumber
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.27
    type: DisplayString
    help: The part number of the disk. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.27
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskSASAddress
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.28
    type: DisplayString
    help: The SAS address of the physical disk. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.28
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskNegotiatedSpeed
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.29
    type: gauge
    help: The data transfer speed that the disk negotiated while spinning up in Gigbits
      per second (Gbps) - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.29
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: unknown
      2: oneDotFiveGbps
      3: threeGbps
      4: sixGbps
      5: twelveGbps
      6: fiveGTps
      7: eightGTps
  - name: physicalDiskCapableSpeed
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.30
    type: gauge
    help: The maximum data transfer speed supported by the disk in Gigbits per second
      (Gbps) - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.30
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: unknown
      2: oneDotFiveGbps
      3: threeGbps
      4: sixGbps
      5: twelveGbps
      6: fiveGTps
      7: eightGTps
  - name: physicalDiskSmartAlertIndication
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.31
    type: gauge
    help: Indicates whether the physical disk has received a predictive failure alert.
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.31
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskManufactureDay
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.32
    type: DisplayString
    help: The day of the week (1=Sunday thru 7=Saturday) on which the physical disk
      was manufactured. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.32
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskManufactureWeek
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.33
    type: DisplayString
    help: The week (1 thru 53) in which the physical disk was manufactured. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.33
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskManufactureYear
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.34
    type: DisplayString
    help: The four digit year in which the physical disk was manufactured. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.34
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskMediaType
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.35
    type: gauge
    help: The media type of the physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.35
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: unknown
      2: hdd
      3: ssd
  - name: physicalDiskPowerState
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.42
    type: gauge
    help: The power state of the physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.42
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: other
      2: spunUp
      3: spunDown
      4: transition
      5: "on"
  - name: physicalDiskRemainingRatedWriteEndurance
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.49
    type: gauge
    help: This property is applicable to SSD media type only - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.49
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskOperationalState
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.50
    type: gauge
    help: The state of the physical disk when there are progressive operations ongoing
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.50
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: notApplicable
      2: rebuild
      3: clear
      4: copyback
  - name: physicalDiskProgress
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.51
    type: gauge
    help: The progress percentage of the operation that is being performed on the
      physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.51
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskSecurityStatus
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.52
    type: gauge
    help: The security/encryption status of the physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.52
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: supported
      2: notSupported
      3: secured
      4: locked
      5: foreign
  - name: physicalDiskFormFactor
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.53
    type: gauge
    help: The form factor of the physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.53
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: unknown
      2: oneDotEight
      3: twoDotFive
      4: threeDotFive
  - name: physicalDiskFQDD
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.54
    type: DisplayString
    help: The physical disk's Fully Qualified Device Descriptor (FQDD) as represented
      in Storage Management. - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.54
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskDisplayName
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.55
    type: DisplayString
    help: The physical disk's friendly FQDD as represented in Storage Management.
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.55
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskT10PICapability
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.57
    type: gauge
    help: Indicates whether the physical disk supports the T10 PI (Protection Information)
      - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.57
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: other
      2: capable
      3: notCapable
  - name: physicalDiskBlockSizeInBytes
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.58
    type: gauge
    help: The block size (in bytes) of the physical disk - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.58
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskProtocolVersion
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.59
    type: DisplayString
    help: Applicable for NVMe devices only - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.59
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
  - name: physicalDiskPCIeNegotiatedLinkWidth
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.60
    type: gauge
    help: Applicable for NVMe devices only - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.60
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: other
      2: notApplicable
      3: byOne
      4: byTwp
      5: byFour
      6: byEight
      7: bySixteen
      8: byThirtyTwp
  - name: physicalDiskPCIeCapableLinkWidth
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.61
    type: gauge
    help: Applicable for NVMe devices only - 1.3.6.1.4.1.674.10892.5.5.1.20.130.4.1.61
    indexes:
    - labelname: physicalDiskNumber
      type: gauge
    enum_values:
      1: other
      2: notApplicable
      3: byOne
      4: byTwp
      5: byFour
      6: byEight
      7: bySixteen
      8: byThirtyTwp
  - name: virtualDiskNumber
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.1
    type: gauge
    help: Instance number of this virtual disk entry. - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.1
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskName
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.2
    type: DisplayString
    help: The virtual disk's label as entered by the user. - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.2
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskState
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.4
    type: gauge
    help: 'The current state of this virtual disk (which includes any member physical
      disks.) Possible states: 1: The current state could not be determined - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.4'
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: unknown
      2: online
      3: failed
      4: degraded
  - name: virtualDiskSizeInMB
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.6
    type: gauge
    help: The size of the virtual disk in megabytes. - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.6
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskWritePolicy
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.10
    type: gauge
    help: The write policy used by the controller for write operations on this virtual
      disk - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.10
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: writeThrough
      2: writeBack
      3: writeBackForce
  - name: virtualDiskReadPolicy
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.11
    type: gauge
    help: The read policy used by the controller for read operations on this virtual
      disk - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.11
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: noReadAhead
      2: readAhead
      3: adaptiveReadAhead
  - name: virtualDiskLayout
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.13
    type: gauge
    help: The virtual disk's RAID type - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.13
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: other
      2: r0
      3: r1
      4: r5
      5: r6
      6: r10
      7: r50
      8: r60
      9: concatRaid1
      10: concatRaid5
  - name: virtualDiskStripeSize
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.14
    type: gauge
    help: The stripe size of this virtual disk - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.14
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: other
      2: default
      3: fiveHundredAndTwelvebytes
      4: oneKilobytes
      5: twoKilobytes
      6: fourKilobytes
      7: eightKilobytes
      8: sixteenKilobytes
      9: thirtyTwoKilobytes
      10: sixtyFourKilobytes
      11: oneTwentyEightKilobytes
      12: twoFiftySixKilobytes
      13: fiveOneTwoKilobytes
      14: oneMegabye
      15: twoMegabytes
      16: fourMegabytes
      17: eightMegabytes
      18: sixteenMegabytes
  - name: virtualDiskComponentStatus
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.20
    type: gauge
    help: The status of the virtual disk itself without the propagation of any contained
      component status - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.20
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: ok
      4: nonCritical
      5: critical
      6: nonRecoverable
  - name: virtualDiskBadBlocksDetected
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.23
    type: gauge
    help: Indicates whether the virtual disk has bad blocks. - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.23
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskSecured
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.24
    type: gauge
    help: Indicates whether the virtual disk is secured or not. - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.24
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskIsCacheCade
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.25
    type: gauge
    help: Indicates whether the virtual disk is being used as a secondary cache by
      the controller. - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.25
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskDiskCachePolicy
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.26
    type: gauge
    help: 'The cache policy of the physical disks that are part of this virtual disk
      Possible values: 1: Enabled - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.26'
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: enabled
      2: disabled
      3: defullt
  - name: virtualDiskOperationalState
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.30
    type: gauge
    help: The state of the virtual disk when there are progressive operations ongoing
      - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.30
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: notApplicable
      2: reconstructing
      3: resynching
      4: initializing
      5: backgroundInit
  - name: virtualDiskProgress
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.31
    type: gauge
    help: The progress percentage of the operation that is being performed on the
      virtual disk - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.31
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskAvailableProtocols
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.32
    type: DisplayString
    help: List of protocols support by physical disks part of this virtual disk -
      1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.32
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskMediaType
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.33
    type: DisplayString
    help: List of media types of the physical disks part of this virtual disk - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.33
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskRemainingRedundancy
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.34
    type: gauge
    help: The number of physical disks which can be lost before the virtual disk loses
      its redundancy. - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.34
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskFQDD
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.35
    type: OctetString
    help: The virtual disk's Fully Qualified Device Descriptor (FQDD) as represented
      in Storage Management. - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.35
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskDisplayName
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.36
    type: DisplayString
    help: The virtual disk's friendly FQDD as represented in Storage Management. -
      1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.36
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
  - name: virtualDiskT10PIStatus
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.37
    type: gauge
    help: Indicates whether the virtual disk supports the T10 PI (Protection Information)
      - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.37
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
    enum_values:
      1: other
      2: enabled
      3: disabled
  - name: virtualDiskBlockSizeInBytes
    oid: 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.38
    type: gauge
    help: The block size (in bytes) of the physical disk part of the virtual disk
      - 1.3.6.1.4.1.674.10892.5.5.1.20.140.1.1.38
    indexes:
    - labelname: virtualDiskNumber
      type: gauge
hpe_ilo:
  walk:
  - 1.3.6.1.4.1.232.1.2.2.1.1
  - 1.3.6.1.4.1.232.11
  - 1.3.6.1.4.1.232.14
  - 1.3.6.1.4.1.232.3.2.2.1
  - 1.3.6.1.4.1.232.3.2.3.1.1
  - 1.3.6.1.4.1.232.3.2.5.1.1
  - 1.3.6.1.4.1.232.5
  - 1.3.6.1.4.1.232.6.2.14.13.1.6
  - 1.3.6.1.4.1.232.6.2.15
  - 1.3.6.1.4.1.232.6.2.16
  - 1.3.6.1.4.1.232.6.2.17
  - 1.3.6.1.4.1.232.6.2.6.7.1
  - 1.3.6.1.4.1.232.6.2.6.8.1
  - 1.3.6.1.4.1.232.6.2.9
  - 1.3.6.1.4.1.232.9.2.2
  get:
  - 1.3.6.1.2.1.1.3.0
  metrics:
  - name: sysUpTime
    oid: 1.3.6.1.2.1.1.3
    type: gauge
    help: The time (in hundredths of a second) since the network management portion
      of the system was last re-initialized. - 1.3.6.1.2.1.1.3
  - name: cpqSeCpuUnitIndex
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.1
    type: gauge
    help: This is a number that uniquely specifies a processor unit - 1.3.6.1.4.1.232.1.2.2.1.1.1
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuSlot
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.2
    type: gauge
    help: This value represents this processor`s slot - 1.3.6.1.4.1.232.1.2.2.1.1.2
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuName
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.3
    type: DisplayString
    help: The name of this processor - 1.3.6.1.4.1.232.1.2.2.1.1.3
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuSpeed
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.4
    type: gauge
    help: The current internal speed of this processor in megahertz - 1.3.6.1.4.1.232.1.2.2.1.1.4
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuStep
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.5
    type: gauge
    help: This step of the processor - 1.3.6.1.4.1.232.1.2.2.1.1.5
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuStatus
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.6
    type: gauge
    help: The status of the processor - 1.3.6.1.4.1.232.1.2.2.1.1.6
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
    enum_values:
      1: unknown
      2: ok
      3: degraded
      4: failed
      5: disabled
  - name: cpqSeCpuExtSpeed
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.7
    type: gauge
    help: This is the external frequency in megahertz of the processor bus - 1.3.6.1.4.1.232.1.2.2.1.1.7
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuDesigner
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.8
    type: gauge
    help: This attribute specifies the manufacturer which designs this CPU. - 1.3.6.1.4.1.232.1.2.2.1.1.8
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
    enum_values:
      1: unknown
      2: intel
      3: amd
      4: cyrix
      5: ti
      6: nexgen
      7: compaq
      8: samsung
      9: mitsubishi
      10: mips
  - name: cpqSeCpuSocketNumber
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.9
    type: gauge
    help: The physical socket number of the CPU chip - 1.3.6.1.4.1.232.1.2.2.1.1.9
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuThreshPassed
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.10
    type: gauge
    help: CPU threshold passed (Exceeded) - 1.3.6.1.4.1.232.1.2.2.1.1.10
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
    enum_values:
      1: unsupported
      2: "false"
      3: "true"
  - name: cpqSeCpuHwLocation
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.11
    type: DisplayString
    help: A text description of the hardware location, on complex multi SBB hardware
      only, for the CPU - 1.3.6.1.4.1.232.1.2.2.1.1.11
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuCellTablePtr
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.12
    type: gauge
    help: This is the index for the cell in cpqSeCellTable where this CPU is physically
      located. - 1.3.6.1.4.1.232.1.2.2.1.1.12
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuPowerpodStatus
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.13
    type: gauge
    help: This is the status of CPU power pod - 1.3.6.1.4.1.232.1.2.2.1.1.13
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
    enum_values:
      1: notfailed
      2: failed
  - name: cpqSeCpuArchitectureRevision
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.14
    type: DisplayString
    help: This is the CPU architecture revision. - 1.3.6.1.4.1.232.1.2.2.1.1.14
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuCore
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.15
    type: gauge
    help: The number of cores in this CPU module - 1.3.6.1.4.1.232.1.2.2.1.1.15
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUSerialNumber
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.16
    type: DisplayString
    help: The OEM serial number of the CPU. - 1.3.6.1.4.1.232.1.2.2.1.1.16
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUPartNumber
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.17
    type: DisplayString
    help: The OEM part number of the CPU. - 1.3.6.1.4.1.232.1.2.2.1.1.17
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUSerialNumberMfgr
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.18
    type: DisplayString
    help: The manufacturer serial number of the CPU. - 1.3.6.1.4.1.232.1.2.2.1.1.18
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUPartNumberMfgr
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.19
    type: DisplayString
    help: The manufacturer part number of the CPU. - 1.3.6.1.4.1.232.1.2.2.1.1.19
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUCoreIndex
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.20
    type: gauge
    help: This is a number that uniquely identifies a core in a CPU unit. - 1.3.6.1.4.1.232.1.2.2.1.1.20
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUMaxSpeed
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.21
    type: gauge
    help: This is the maximum internal speed in megahertz this processor can support
      - 1.3.6.1.4.1.232.1.2.2.1.1.21
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUCoreThreadIndex
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.22
    type: gauge
    help: This is an unique number to identify the running threads in a CPU core.
      - 1.3.6.1.4.1.232.1.2.2.1.1.22
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUChipGenerationName
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.23
    type: DisplayString
    help: CPU chip generation name e.g - 1.3.6.1.4.1.232.1.2.2.1.1.23
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCPUMultiThreadStatus
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.24
    type: gauge
    help: This OID identifies whether the CPU threading is enabled or not. - 1.3.6.1.4.1.232.1.2.2.1.1.24
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
    enum_values:
      1: unknown
      2: enabled
      3: disabled
  - name: cpqSeCPUCoreMaxThreads
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.25
    type: gauge
    help: This OID indicates the maximum number of threads that a cpu core is capable
      of. - 1.3.6.1.4.1.232.1.2.2.1.1.25
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuLowPowerStatus
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.26
    type: gauge
    help: Servers like Itanium has capability to lower power supply to CPU if it is
      idle for specified period of time - 1.3.6.1.4.1.232.1.2.2.1.1.26
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
    enum_values:
      1: unknown
      2: lowpowered
      3: normalpowered
      4: highpowered
  - name: cpqSeCpuPrimary
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.27
    type: gauge
    help: On SMP systems one of the CPU is set to Primary and the other CPUs as secondary
      - 1.3.6.1.4.1.232.1.2.2.1.1.27
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
    enum_values:
      1: unknown
      2: "false"
      3: "true"
  - name: cpqSeCpuCoreSteppingText
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.28
    type: DisplayString
    help: The processor stepping version string - 1.3.6.1.4.1.232.1.2.2.1.1.28
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuCurrentPerformanceState
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.29
    type: gauge
    help: This OID returns the current performance state of this processor - 1.3.6.1.4.1.232.1.2.2.1.1.29
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuMinPerformanceState
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.30
    type: gauge
    help: This OID returns the minimum performance state set for this processor -
      1.3.6.1.4.1.232.1.2.2.1.1.30
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqSeCpuMaxPerformanceState
    oid: 1.3.6.1.4.1.232.1.2.2.1.1.31
    type: gauge
    help: This OID returns the maximum performance state set for this processor -
      1.3.6.1.4.1.232.1.2.2.1.1.31
    indexes:
    - labelname: cpqSeCpuUnitIndex
      type: gauge
  - name: cpqHoMibRevMajor
    oid: 1.3.6.1.4.1.232.11.1.1
    type: gauge
    help: The Major Revision level of the MIB - 1.3.6.1.4.1.232.11.1.1
  - name: cpqHoMibRevMinor
    oid: 1.3.6.1.4.1.232.11.1.2
    type: gauge
    help: The Minor Revision level of the MIB - 1.3.6.1.4.1.232.11.1.2
  - name: cpqHoMibCondition
    oid: 1.3.6.1.4.1.232.11.1.3
    type: gauge
    help: The overall condition - 1.3.6.1.4.1.232.11.1.3
    enum_values:
      1: unknown
      2: ok
      3: degraded
      4: failed
  - name: cpqHoOsCommonPollFreq
    oid: 1.3.6.1.4.1.232.11.2.1.4.1
    type: gauge
    help: The Insight Agent`s polling frequency - 1.3.6.1.4.1.232.11.2.1.4.1
  - name: cpqHoOsCommonModuleIndex
    oid: 1.3.6.1.4.1.232.11.2.1.4.2.1.1
    type: gauge
    help: A unique index for this module description. - 1.3.6.1.4.1.232.11.2.1.4.2.1.1
    indexes:
    - labelname: cpqHoOsCommonModuleIndex
      type: gauge
  - name: cpqHoOsCommonModuleName
    oid: 1.3.6.1.4.1.232.11.2.1.4.2.1.2
    type: DisplayString
    help: The module name. - 1.3.6.1.4.1.232.11.2.1.4.2.1.2
    indexes:
    - labelname: cpqHoOsCommonModuleIndex
      type: gauge
  - name: cpqHoOsCommonModuleVersion
    oid: 1.3.6.1.4.1.232.11.2.1.4.2.1.3
    type: DisplayString
    help: The module version in XX.YY format - 1.3.6.1.4.1.232.11.2.1.4.2.1.3
    indexes:
    - labelname: cpqHoOsCommonModuleIndex
      type: gauge
  - name: cpqHoOsCommonModuleDate
    oid: 1.3.6.1.4.1.232.11.2.1.4.2.1.4
    type: OctetString
    help: The module date - 1.3.6.1.4.1.232.11.2.1.4.2.1.4
    indexes:
    - labelname: cpqHoOsCommonModuleIndex
      type: gauge
  - name: cpqHoOsCommonModulePurpose
    oid: 1.3.6.1.4.1.232.11.2.1.4.2.1.5
    type: DisplayString
    help: The purpose of the module described in this entry. - 1.3.6.1.4.1.232.11.2.1.4.2.1.5
    indexes:
    - labelname: cpqHoOsCommonModuleIndex
      type: gauge
  - name: cpqHoName
    oid: 1.3.6.1.4.1.232.11.2.2.1
    type: DisplayString
    help: The name of the host operating system (OS). - 1.3.6.1.4.1.232.11.2.2.1
  - name: cpqHoVersion
    oid: 1.3.6.1.4.1.232.11.2.2.2
    type: DisplayString
    help: The version of the host OS. - 1.3.6.1.4.1.232.11.2.2.2
  - name: cpqHoDesc
    oid: 1.3.6.1.4.1.232.11.2.2.3
    type: DisplayString
    help: A further description of the host OS. - 1.3.6.1.4.1.232.11.2.2.3
  - name: cpqHoOsType
    oid: 1.3.6.1.4.1.232.11.2.2.4
    type: gauge
    help: Host Operating system enumeration. - 1.3.6.1.4.1.232.11.2.2.4
    enum_values:
      1: other
      2: netware
      3: windowsnt
      4: sco-unix
      5: unixware
      6: os-2
      7: ms-dos
      8: dos-windows
      9: windows95
      10: windows98
      11: open-vms
      12: nsk
      13: windowsCE
      14: linux
      15: windows2000
      16: tru64UNIX
      17: windows2003
      18: windows2003-x64
      19: solaris
      20: windows2003-ia64
      21: windows2008
      22: windows2008-x64
      23: windows2008-ia64
      24: vmware-esx
      25: vmware-esxi
      26: windows2012
      27: windows7
      28: windows7-x64
      29: windows8
      30: windows8-x64
      31: windows81
      32: windows81-x64
      33: windowsxp
      34: windowsxp-x64
      35: windowsvista
      36: windowsvista-x64
      37: windows2008-r2
      38: windows2012-r2
      39: rhel
      40: rhel-64
      41: solaris-64
      42: sles
      43: sles-64
      44: ubuntu
      45: ubuntu-64
      46: debian
      47: debian-64
      48: linux-64-bit
      49: other-64-bit
      50: centos-32bit
      51: centos-64bit
      52: oracle-linux32
      53: oracle-linux64
      54: apple-osx
      55: windows2016
      56: nanoserver
      57: windows2019
      58: windows10-x64
      59: windows2022
      60: azurestackhciOS-20h2
      61: azurestackhciOS-21h2
  - name: cpqHoTelnet
    oid: 1.3.6.1.4.1.232.11.2.2.5
    type: gauge
    help: Telnet on socket 23 is available. - 1.3.6.1.4.1.232.11.2.2.5
    enum_values:
      1: other
      2: available
      3: notavailable
  - name: cpqHoSystemRole
    oid: 1.3.6.1.4.1.232.11.2.2.6
    type: DisplayString
    help: The system role - 1.3.6.1.4.1.232.11.2.2.6
  - name: cpqHoSystemRoleDetail
    oid: 1.3.6.1.4.1.232.11.2.2.7
    type: DisplayString
    help: The system detailed description - 1.3.6.1.4.1.232.11.2.2.7
  - name: cpqHoCrashDumpState
    oid: 1.3.6.1.4.1.232.11.2.2.8
    type: gauge
    help: Crash dump state - 1.3.6.1.4.1.232.11.2.2.8
    enum_values:
      1: completememorydump
      2: kernelmemorydump
      3: smallmemorydump
      4: none
  - name: cpqHoCrashDumpCondition
    oid: 1.3.6.1.4.1.232.11.2.2.9
    type: gauge
    help: The condition of the Crash dump configuration. - 1.3.6.1.4.1.232.11.2.2.9
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHoCrashDumpMonitoring
    oid: 1.3.6.1.4.1.232.11.2.2.10
    type: gauge
    help: Enable/disable crash dump monitoring - 1.3.6.1.4.1.232.11.2.2.10
    enum_values:
      1: enabled
      2: disabled
  - name: cpqHoMaxLogicalCPUSupported
    oid: 1.3.6.1.4.1.232.11.2.2.11
    type: gauge
    help: Maximum number of logical CPUs supported by Operating System. - 1.3.6.1.4.1.232.11.2.2.11
  - name: cpqHoSystemName
    oid: 1.3.6.1.4.1.232.11.2.2.12
    type: DisplayString
    help: Full computer name of the host - 1.3.6.1.4.1.232.11.2.2.12
  - name: cpqHosysDescr
    oid: 1.3.6.1.4.1.232.11.2.2.13
    type: DisplayString
    help: The value that would be returned in the RFC-1213 sysDescr MIB element -
      1.3.6.1.4.1.232.11.2.2.13
  - name: cpqHoCpuUtilUnitIndex
    oid: 1.3.6.1.4.1.232.11.2.3.1.1.1
    type: gauge
    help: This number uniquely specifies a processor unit - 1.3.6.1.4.1.232.11.2.3.1.1.1
    indexes:
    - labelname: cpqHoCpuUtilUnitIndex
      type: gauge
  - name: cpqHoCpuUtilMin
    oid: 1.3.6.1.4.1.232.11.2.3.1.1.2
    type: gauge
    help: The CPU utilization as a percentage of the theoretical maximum during the
      last minute - 1.3.6.1.4.1.232.11.2.3.1.1.2
    indexes:
    - labelname: cpqHoCpuUtilUnitIndex
      type: gauge
  - name: cpqHoCpuUtilFiveMin
    oid: 1.3.6.1.4.1.232.11.2.3.1.1.3
    type: gauge
    help: The CPU utilization as a percentage of the theoretical maximum during the
      last five minutes - 1.3.6.1.4.1.232.11.2.3.1.1.3
    indexes:
    - labelname: cpqHoCpuUtilUnitIndex
      type: gauge
  - name: cpqHoCpuUtilThirtyMin
    oid: 1.3.6.1.4.1.232.11.2.3.1.1.4
    type: gauge
    help: The CPU utilization as a percentage of the theoretical maximum during the
      last thirty minutes - 1.3.6.1.4.1.232.11.2.3.1.1.4
    indexes:
    - labelname: cpqHoCpuUtilUnitIndex
      type: gauge
  - name: cpqHoCpuUtilHour
    oid: 1.3.6.1.4.1.232.11.2.3.1.1.5
    type: gauge
    help: The CPU utilization as a percentage of the theoretical maximum during the
      last hour - 1.3.6.1.4.1.232.11.2.3.1.1.5
    indexes:
    - labelname: cpqHoCpuUtilUnitIndex
      type: gauge
  - name: cpqHoCpuUtilHwLocation
    oid: 1.3.6.1.4.1.232.11.2.3.1.1.6
    type: DisplayString
    help: A text description of the hardware location, on complex multi SBB hardware
      only, for the CPU - 1.3.6.1.4.1.232.11.2.3.1.1.6
    indexes:
    - labelname: cpqHoCpuUtilUnitIndex
      type: gauge
  - name: cpqHoFileSysIndex
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.1
    type: gauge
    help: An index that uniquely specifies this entry. - 1.3.6.1.4.1.232.11.2.4.1.1.1
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
  - name: cpqHoFileSysDesc
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.2
    type: DisplayString
    help: A description of the file system include the GUID. - 1.3.6.1.4.1.232.11.2.4.1.1.2
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
  - name: cpqHoFileSysSpaceTotal
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.3
    type: gauge
    help: The file system size in megabytes - 1.3.6.1.4.1.232.11.2.4.1.1.3
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
  - name: cpqHoFileSysSpaceUsed
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.4
    type: gauge
    help: The megabytes of file system space currently in use - 1.3.6.1.4.1.232.11.2.4.1.1.4
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
  - name: cpqHoFileSysPercentSpaceUsed
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.5
    type: gauge
    help: The percent of file system space currently in use - 1.3.6.1.4.1.232.11.2.4.1.1.5
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
  - name: cpqHoFileSysAllocUnitsTotal
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.6
    type: gauge
    help: The total number of files (directory entries) that can be stored on the
      file system if a limit exists other than total space used - 1.3.6.1.4.1.232.11.2.4.1.1.6
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
  - name: cpqHoFileSysAllocUnitsUsed
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.7
    type: gauge
    help: The number of files (directory entries) on this file system - 1.3.6.1.4.1.232.11.2.4.1.1.7
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
  - name: cpqHoFileSysStatus
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.8
    type: gauge
    help: The Threshold Status - 1.3.6.1.4.1.232.11.2.4.1.1.8
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
    enum_values:
      1: unknown
      2: ok
      3: degraded
      4: failed
  - name: cpqHoFileSysShortDesc
    oid: 1.3.6.1.4.1.232.11.2.4.1.1.9
    type: DisplayString
    help: A description of the file system. - 1.3.6.1.4.1.232.11.2.4.1.1.9
    indexes:
    - labelname: cpqHoFileSysIndex
      type: gauge
  - name: cpqHoFileSysCondition
    oid: 1.3.6.1.4.1.232.11.2.4.2
    type: gauge
    help: The overall condition of File System Threshold - 1.3.6.1.4.1.232.11.2.4.2
    enum_values:
      1: unknown
      2: ok
      3: degraded
      4: failed
  - name: cpqHoIfPhysMapIndex
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.1
    type: gauge
    help: An index that uniquely specifies this entry - 1.3.6.1.4.1.232.11.2.5.1.1.1
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
  - name: cpqHoIfPhysMapSlot
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.2
    type: gauge
    help: The number of the slot containing the physical hardware that implements
      this interface - 1.3.6.1.4.1.232.11.2.5.1.1.2
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
  - name: cpqHoIfPhysMapIoBaseAddr
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.3
    type: gauge
    help: The base I/O address of the physical hardware that implements this interface.
      - 1.3.6.1.4.1.232.11.2.5.1.1.3
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
  - name: cpqHoIfPhysMapIrq
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.4
    type: gauge
    help: The number of the IRQ (interrupt) used for this physical hardware interface
      - 1.3.6.1.4.1.232.11.2.5.1.1.4
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
  - name: cpqHoIfPhysMapDma
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.5
    type: gauge
    help: The number of the DMA channel used for this physical hardware interface
      - 1.3.6.1.4.1.232.11.2.5.1.1.5
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
  - name: cpqHoIfPhysMapMemBaseAddr
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.6
    type: gauge
    help: The base memory address used by this physical hardware interface - 1.3.6.1.4.1.232.11.2.5.1.1.6
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
  - name: cpqHoIfPhysMapPort
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.7
    type: gauge
    help: The port number of the interface for multi-port NICs - 1.3.6.1.4.1.232.11.2.5.1.1.7
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
  - name: cpqHoIfPhysMapDuplexState
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.8
    type: gauge
    help: This variable describes the configured duplex state of the NIC. - 1.3.6.1.4.1.232.11.2.5.1.1.8
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
    enum_values:
      1: other
      2: half
      3: full
  - name: cpqHoIfPhysMapCondition
    oid: 1.3.6.1.4.1.232.11.2.5.1.1.9
    type: gauge
    help: The condition of this interface. - 1.3.6.1.4.1.232.11.2.5.1.1.9
    indexes:
    - labelname: cpqHoIfPhysMapIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHoIfPhysMapOverallCondition
    oid: 1.3.6.1.4.1.232.11.2.5.2
    type: gauge
    help: The overall condition of all interfaces. - 1.3.6.1.4.1.232.11.2.5.2
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHoSWRunningIndex
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.1
    type: gauge
    help: An index that uniquely specifies this entry. - 1.3.6.1.4.1.232.11.2.6.1.1.1
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningName
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.2
    type: DisplayString
    help: The name of the software. - 1.3.6.1.4.1.232.11.2.6.1.1.2
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningDesc
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.3
    type: DisplayString
    help: A description of the software. - 1.3.6.1.4.1.232.11.2.6.1.1.3
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningVersion
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.4
    type: DisplayString
    help: The version of the software - 1.3.6.1.4.1.232.11.2.6.1.1.4
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningDate
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.5
    type: OctetString
    help: The software date - 1.3.6.1.4.1.232.11.2.6.1.1.5
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningMonitor
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.6
    type: gauge
    help: The user specified monitor option for a process. - 1.3.6.1.4.1.232.11.2.6.1.1.6
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
    enum_values:
      1: other
      2: start
      3: stop
      4: startAndStop
      5: count
      6: startAndCount
      7: countAndStop
      8: startCountAndStop
  - name: cpqHoSWRunningState
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.7
    type: gauge
    help: The current state of monitored process. - 1.3.6.1.4.1.232.11.2.6.1.1.7
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
    enum_values:
      1: other
      2: started
      3: stopped
  - name: cpqHoSWRunningCount
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.8
    type: gauge
    help: For each process name, the number of instances of the process running on
      the system is kept count of, in this variable. - 1.3.6.1.4.1.232.11.2.6.1.1.8
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningCountMin
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.9
    type: gauge
    help: This is the lower threshold on cpqHoSWRunningCount to be set by the user.
      - 1.3.6.1.4.1.232.11.2.6.1.1.9
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningCountMax
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.10
    type: gauge
    help: This is the upper threshold on cpqHoSWRunningCount to be set by the user.
      - 1.3.6.1.4.1.232.11.2.6.1.1.10
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningEventTime
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.11
    type: OctetString
    help: The system time at which the monitored event, as per cpqHoSWRunningMonitor,
      last occurred - 1.3.6.1.4.1.232.11.2.6.1.1.11
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningStatus
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.12
    type: gauge
    help: The overall alarm state of the resources managed by the software, or the
      software itself. - 1.3.6.1.4.1.232.11.2.6.1.1.12
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
    enum_values:
      1: unknown
      2: normal
      3: warning
      4: minor
      5: major
      6: critical
      7: disabled
  - name: cpqHoSWRunningConfigStatus
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.13
    type: gauge
    help: The configuration state of the software - 1.3.6.1.4.1.232.11.2.6.1.1.13
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
    enum_values:
      1: unknown
      2: starting
      3: initialized
      4: configured
      5: operational
  - name: cpqHoSWRunningIdentifier
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.14
    type: DisplayString
    help: The unique identifier of the sofware - 1.3.6.1.4.1.232.11.2.6.1.1.14
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
  - name: cpqHoSWRunningRedundancyMode
    oid: 1.3.6.1.4.1.232.11.2.6.1.1.15
    type: gauge
    help: When the software is running in a high availability mode, the failover mode
      of this instance of the software. - 1.3.6.1.4.1.232.11.2.6.1.1.15
    indexes:
    - labelname: cpqHoSWRunningIndex
      type: gauge
    enum_values:
      1: unknown
      2: master
      3: backup
      4: slave
  - name: cpqHoSwRunningTrapDesc
    oid: 1.3.6.1.4.1.232.11.2.6.2
    type: DisplayString
    help: The error message for a process monitor event. - 1.3.6.1.4.1.232.11.2.6.2
  - name: cpqHoSwVerNextIndex
    oid: 1.3.6.1.4.1.232.11.2.7.1
    type: gauge
    help: The index of the next available entry in the cpqHoSwVer table - 1.3.6.1.4.1.232.11.2.7.1
  - name: cpqHoSwVerIndex
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.1
    type: gauge
    help: An index that uniquely identifies an entry in the cpqHoSwVer table. - 1.3.6.1.4.1.232.11.2.7.2.1.1
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
  - name: cpqHoSwVerStatus
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.2
    type: gauge
    help: Status for the software item. - 1.3.6.1.4.1.232.11.2.7.2.1.2
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
    enum_values:
      1: other
      2: loaded
      3: notloaded
  - name: cpqHoSwVerType
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.3
    type: gauge
    help: Type of software item. - 1.3.6.1.4.1.232.11.2.7.2.1.3
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
    enum_values:
      1: other
      2: driver
      3: agent
      4: sysutil
      5: application
      6: keyfile
      7: firmware
  - name: cpqHoSwVerName
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.4
    type: DisplayString
    help: The name of this software item. - 1.3.6.1.4.1.232.11.2.7.2.1.4
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
  - name: cpqHoSwVerDescription
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.5
    type: DisplayString
    help: The description of this software item. - 1.3.6.1.4.1.232.11.2.7.2.1.5
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
  - name: cpqHoSwVerDate
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.6
    type: OctetString
    help: The date of the software item, if any - 1.3.6.1.4.1.232.11.2.7.2.1.6
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
  - name: cpqHoSwVerLocation
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.7
    type: DisplayString
    help: The location of this software item on the server. - 1.3.6.1.4.1.232.11.2.7.2.1.7
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
  - name: cpqHoSwVerVersion
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.8
    type: DisplayString
    help: An string that specifies the version of this item. - 1.3.6.1.4.1.232.11.2.7.2.1.8
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
  - name: cpqHoSwVerVersionBinary
    oid: 1.3.6.1.4.1.232.11.2.7.2.1.9
    type: DisplayString
    help: An string that specifies the version of this item based on the binary version
      resource. - 1.3.6.1.4.1.232.11.2.7.2.1.9
    indexes:
    - labelname: cpqHoSwVerIndex
      type: gauge
  - name: cpqHoSwVerAgentsVer
    oid: 1.3.6.1.4.1.232.11.2.7.3
    type: DisplayString
    help: A string that specifies the version of the Insight Management Agents running
      on the system. - 1.3.6.1.4.1.232.11.2.7.3
  - name: cpqHoGenericData
    oid: 1.3.6.1.4.1.232.11.2.8.1
    type: DisplayString
    help: Data for the generic trap. - 1.3.6.1.4.1.232.11.2.8.1
  - name: cpqHoCriticalSoftwareUpdateData
    oid: 1.3.6.1.4.1.232.11.2.8.2
    type: DisplayString
    help: Data for the Critical Software Update trap. - 1.3.6.1.4.1.232.11.2.8.2
  - name: cpqHoSwPerfAppErrorDesc
    oid: 1.3.6.1.4.1.232.11.2.9.1
    type: DisplayString
    help: This string holds error information about the last application error that
      occurred in the system. - 1.3.6.1.4.1.232.11.2.9.1
  - name: cpqHoMibStatusArray
    oid: 1.3.6.1.4.1.232.11.2.10.1
    type: OctetString
    help: The MIB Status Array is an array of MIB status structures - 1.3.6.1.4.1.232.11.2.10.1
  - name: cpqHoConfigChangedDate
    oid: 1.3.6.1.4.1.232.11.2.10.2
    type: OctetString
    help: The date/time when the agents were last loaded - 1.3.6.1.4.1.232.11.2.10.2
  - name: cpqHoGUID
    oid: 1.3.6.1.4.1.232.11.2.10.3
    type: OctetString
    help: The globally unique identifier of this physical server - 1.3.6.1.4.1.232.11.2.10.3
  - name: cpqHoCodeServer
    oid: 1.3.6.1.4.1.232.11.2.10.4
    type: gauge
    help: This item indicates how many code server shares are currently configured
      on the system - 1.3.6.1.4.1.232.11.2.10.4
  - name: cpqHoWebMgmtPort
    oid: 1.3.6.1.4.1.232.11.2.10.5
    type: gauge
    help: This item indicates the port used by the Insight Web Agent - 1.3.6.1.4.1.232.11.2.10.5
  - name: cpqHoGUIDCanonical
    oid: 1.3.6.1.4.1.232.11.2.10.6
    type: OctetString
    help: The globally unique identifier in canonical format of this physical server
      - 1.3.6.1.4.1.232.11.2.10.6
  - name: cpqHoMibHealthStatusArray
    oid: 1.3.6.1.4.1.232.11.2.10.7
    type: OctetString
    help: 'The MIB Health Status Array is an array of status values representing an
      overall status in element 0 follwed by server and storage status values as follows:
      Octet Element Field ======== ======= ========= 0 0 Aggregated Status of array
      elements 1 1 Status of element 1 2 2 Status of element 2  - 1.3.6.1.4.1.232.11.2.10.7'
  - name: cpqHoTrapFlags
    oid: 1.3.6.1.4.1.232.11.2.11.1
    type: gauge
    help: The Trap Flags - 1.3.6.1.4.1.232.11.2.11.1
  - name: cpqHoClientLastModified
    oid: 1.3.6.1.4.1.232.11.2.12.1
    type: OctetString
    help: The date/time of the last modification to the client table - 1.3.6.1.4.1.232.11.2.12.1
  - name: cpqHoClientDelete
    oid: 1.3.6.1.4.1.232.11.2.12.2
    type: DisplayString
    help: Setting this variable to the name of a client in the client table will cause
      that row in the table to be deleted - 1.3.6.1.4.1.232.11.2.12.2
  - name: cpqHoClientIndex
    oid: 1.3.6.1.4.1.232.11.2.12.3.1.1
    type: gauge
    help: An index that uniquely specifies this entry. - 1.3.6.1.4.1.232.11.2.12.3.1.1
    indexes:
    - labelname: cpqHoClientIndex
      type: gauge
  - name: cpqHoClientName
    oid: 1.3.6.1.4.1.232.11.2.12.3.1.2
    type: DisplayString
    help: The Win95 machine name of this client. - 1.3.6.1.4.1.232.11.2.12.3.1.2
    indexes:
    - labelname: cpqHoClientIndex
      type: gauge
  - name: cpqHoClientIpxAddress
    oid: 1.3.6.1.4.1.232.11.2.12.3.1.3
    type: OctetString
    help: The IPX address for this client, all octets should be set to 0xff if this
      machine does not support IPX - 1.3.6.1.4.1.232.11.2.12.3.1.3
    indexes:
    - labelname: cpqHoClientIndex
      type: gauge
  - name: cpqHoClientIpAddress
    oid: 1.3.6.1.4.1.232.11.2.12.3.1.4
    type: InetAddressIPv4
    help: The IP address for this client, all octets should be set to 0xff if this
      machine does not support IP - 1.3.6.1.4.1.232.11.2.12.3.1.4
    indexes:
    - labelname: cpqHoClientIndex
      type: gauge
  - name: cpqHoClientCommunity
    oid: 1.3.6.1.4.1.232.11.2.12.3.1.5
    type: DisplayString
    help: A community name that can be used to query the client with SNMP - 1.3.6.1.4.1.232.11.2.12.3.1.5
    indexes:
    - labelname: cpqHoClientIndex
      type: gauge
  - name: cpqHoClientID
    oid: 1.3.6.1.4.1.232.11.2.12.3.1.6
    type: OctetString
    help: The unique identifier of this client. - 1.3.6.1.4.1.232.11.2.12.3.1.6
    indexes:
    - labelname: cpqHoClientIndex
      type: gauge
  - name: cpqHoPhysicalMemorySize
    oid: 1.3.6.1.4.1.232.11.2.13.1
    type: gauge
    help: Total amount of physical memory as seen by the OS (in megabytes) - 1.3.6.1.4.1.232.11.2.13.1
  - name: cpqHoPhysicalMemoryFree
    oid: 1.3.6.1.4.1.232.11.2.13.2
    type: gauge
    help: The amount of free physical memory (in megabytes) - 1.3.6.1.4.1.232.11.2.13.2
  - name: cpqHoPagingMemorySize
    oid: 1.3.6.1.4.1.232.11.2.13.3
    type: gauge
    help: Total virtual memory available from the OS (in megabytes) - 1.3.6.1.4.1.232.11.2.13.3
  - name: cpqHoPagingMemoryFree
    oid: 1.3.6.1.4.1.232.11.2.13.4
    type: gauge
    help: Available paging memory (in megabytes) - 1.3.6.1.4.1.232.11.2.13.4
  - name: cpqHoBootPagingFileSize
    oid: 1.3.6.1.4.1.232.11.2.13.5
    type: DisplayString
    help: The paging file size of the boot volume in the format xxxMB or xxxGB, where
      xxx is the paging file size in that unit shown right after it - 1.3.6.1.4.1.232.11.2.13.5
  - name: cpqHoBootPagingFileMinimumSize
    oid: 1.3.6.1.4.1.232.11.2.13.6
    type: DisplayString
    help: Minimum paging file size of the boot volume required to save the memory
      dump in the event of a system crash - 1.3.6.1.4.1.232.11.2.13.6
  - name: cpqHoBootPagingFileVolumeFreeSpace
    oid: 1.3.6.1.4.1.232.11.2.13.7
    type: DisplayString
    help: Free space of the boot volume required to save the memory dump in the event
      of a system crash - 1.3.6.1.4.1.232.11.2.13.7
  - name: cpqHoFwVerIndex
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.1
    type: gauge
    help: Firmware Version Index - 1.3.6.1.4.1.232.11.2.14.1.1.1
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
  - name: cpqHoFwVerCategory
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.2
    type: gauge
    help: Firmware Version Category. - 1.3.6.1.4.1.232.11.2.14.1.1.2
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
    enum_values:
      1: other
      2: storage
      3: nic
      4: rib
      5: system
  - name: cpqHoFwVerDeviceType
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.3
    type: gauge
    help: Firmware Version Device Type. - 1.3.6.1.4.1.232.11.2.14.1.1.3
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
    enum_values:
      1: other
      2: internalArrayController
      3: fibreArrayController
      4: scsiController
      5: fibreChannelTapeController
      6: modularDataRouter
      7: ideCdRomDrive
      8: ideDiskDrive
      9: scsiCdRom-ScsiAttached
      10: scsiDiskDrive-ScsiAttached
      11: scsiTapeDrive-ScsiAttached
      12: scsiTapeLibrary-ScsiAttached
      13: scsiDiskDrive-ArrayAttached
      14: scsiTapeDrive-ArrayAttached
      15: scsiTapeLibrary-ArrayAttached
      16: scsiDiskDrive-FibreAttached
      17: scsiTapeDrive-FibreAttached
      18: scsiTapeLibrary-FibreAttached
      19: scsiEnclosureBackplaneRom-ScsiAttached
      20: scsiEnclosureBackplaneRom-ArrayAttached
      21: scsiEnclosureBackplaneRom-FibreAttached
      22: scsiEnclosureBackplaneRom-ra4x00
      23: systemRom
      24: networkInterfaceController
      25: remoteInsightBoard
      26: sasDiskDrive-SasAttached
      27: sataDiskDrive-SataAttached
      28: usbController
      29: sasControllerAdapter
      30: sataControllerAdapter
      31: systemDevice
      32: fibreChannelHba
      33: convergedNetworkAdapter
      34: ideController
  - name: cpqHoFwVerDisplayName
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.4
    type: DisplayString
    help: Firmware Version Device Display Name - 1.3.6.1.4.1.232.11.2.14.1.1.4
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
  - name: cpqHoFwVerVersion
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.5
    type: DisplayString
    help: Firmware Version - 1.3.6.1.4.1.232.11.2.14.1.1.5
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
  - name: cpqHoFwVerLocation
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.6
    type: DisplayString
    help: Firmware Version Device Location - 1.3.6.1.4.1.232.11.2.14.1.1.6
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
  - name: cpqHoFwVerXmlString
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.7
    type: DisplayString
    help: Firmware Version Xml String - 1.3.6.1.4.1.232.11.2.14.1.1.7
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
  - name: cpqHoFwVerKeyString
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.8
    type: DisplayString
    help: Firmware Version Key String - 1.3.6.1.4.1.232.11.2.14.1.1.8
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
  - name: cpqHoFwVerUpdateMethod
    oid: 1.3.6.1.4.1.232.11.2.14.1.1.9
    type: gauge
    help: Firmware Version update method. - 1.3.6.1.4.1.232.11.2.14.1.1.9
    indexes:
    - labelname: cpqHoFwVerIndex
      type: gauge
    enum_values:
      1: other
      2: noUpdate
      3: softwareflash
      4: replacePhysicalRom
  - name: cpqHoHWInfoPlatform
    oid: 1.3.6.1.4.1.232.11.2.15.1
    type: gauge
    help: Hardware platform type - 1.3.6.1.4.1.232.11.2.15.1
    enum_values:
      1: unknown
      2: cellular
      3: foundation
      4: virtualMachine
      5: serverBlade
  - name: cpqPwrWarnType
    oid: 1.3.6.1.4.1.232.11.2.16.1
    type: DisplayString
    help: Type of power reading on which the warning is based. - 1.3.6.1.4.1.232.11.2.16.1
  - name: cpqPwrWarnThreshold
    oid: 1.3.6.1.4.1.232.11.2.16.2
    type: gauge
    help: The threshold the power usage must exceed (in Watts). - 1.3.6.1.4.1.232.11.2.16.2
  - name: cpqPwrWarnDuration
    oid: 1.3.6.1.4.1.232.11.2.16.3
    type: gauge
    help: Duration that power usage must be exceeded before warning (in minutes).
      - 1.3.6.1.4.1.232.11.2.16.3
  - name: cpqSerialNum
    oid: 1.3.6.1.4.1.232.11.2.16.4
    type: DisplayString
    help: Serial number of the server. - 1.3.6.1.4.1.232.11.2.16.4
  - name: cpqServerUUID
    oid: 1.3.6.1.4.1.232.11.2.16.5
    type: DisplayString
    help: Server UUID - 1.3.6.1.4.1.232.11.2.16.5
  - name: cpqIdeMibRevMajor
    oid: 1.3.6.1.4.1.232.14.1.1
    type: gauge
    help: The Major Revision level - 1.3.6.1.4.1.232.14.1.1
  - name: cpqIdeMibRevMinor
    oid: 1.3.6.1.4.1.232.14.1.2
    type: gauge
    help: The Minor Revision level - 1.3.6.1.4.1.232.14.1.2
  - name: cpqIdeMibCondition
    oid: 1.3.6.1.4.1.232.14.1.3
    type: gauge
    help: The overall condition - 1.3.6.1.4.1.232.14.1.3
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqIdeOsCommonPollFreq
    oid: 1.3.6.1.4.1.232.14.2.1.4.1
    type: gauge
    help: The Insight Agent`s polling frequency - 1.3.6.1.4.1.232.14.2.1.4.1
  - name: cpqIdeOsCommonModuleIndex
    oid: 1.3.6.1.4.1.232.14.2.1.4.2.1.1
    type: gauge
    help: A unique index for this module description. - 1.3.6.1.4.1.232.14.2.1.4.2.1.1
    indexes:
    - labelname: cpqIdeOsCommonModuleIndex
      type: gauge
  - name: cpqIdeOsCommonModuleName
    oid: 1.3.6.1.4.1.232.14.2.1.4.2.1.2
    type: DisplayString
    help: The module name. - 1.3.6.1.4.1.232.14.2.1.4.2.1.2
    indexes:
    - labelname: cpqIdeOsCommonModuleIndex
      type: gauge
  - name: cpqIdeOsCommonModuleVersion
    oid: 1.3.6.1.4.1.232.14.2.1.4.2.1.3
    type: DisplayString
    help: The module version in XX.YY format - 1.3.6.1.4.1.232.14.2.1.4.2.1.3
    indexes:
    - labelname: cpqIdeOsCommonModuleIndex
      type: gauge
  - name: cpqIdeOsCommonModuleDate
    oid: 1.3.6.1.4.1.232.14.2.1.4.2.1.4
    type: OctetString
    help: The module date - 1.3.6.1.4.1.232.14.2.1.4.2.1.4
    indexes:
    - labelname: cpqIdeOsCommonModuleIndex
      type: gauge
  - name: cpqIdeOsCommonModulePurpose
    oid: 1.3.6.1.4.1.232.14.2.1.4.2.1.5
    type: DisplayString
    help: The purpose of the module described in this entry. - 1.3.6.1.4.1.232.14.2.1.4.2.1.5
    indexes:
    - labelname: cpqIdeOsCommonModuleIndex
      type: gauge
  - name: cpqIdeIdentIndex
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.1
    type: gauge
    help: An index that uniquely specifies each device - 1.3.6.1.4.1.232.14.2.2.1.1.1
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
  - name: cpqIdeIdentModel
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.2
    type: DisplayString
    help: IDE Drive Model - 1.3.6.1.4.1.232.14.2.2.1.1.2
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
  - name: cpqIdeIdentSerNum
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.3
    type: DisplayString
    help: IDE Drive Serial Number - 1.3.6.1.4.1.232.14.2.2.1.1.3
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
  - name: cpqIdeIdentFWVers
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.4
    type: DisplayString
    help: IDE Firmware Version - 1.3.6.1.4.1.232.14.2.2.1.1.4
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
  - name: cpqIdeIdentCondition
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.5
    type: gauge
    help: IDE Drive Condition - 1.3.6.1.4.1.232.14.2.2.1.1.5
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqIdeIdentErrorNumber
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.6
    type: DisplayString
    help: IDE Error Number - 1.3.6.1.4.1.232.14.2.2.1.1.6
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
  - name: cpqIdeIdentType
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.7
    type: gauge
    help: IDE Device Type - 1.3.6.1.4.1.232.14.2.2.1.1.7
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
    enum_values:
      1: other
      2: disk
      3: tape
      4: printer
      5: processor
      6: wormDrive
      7: cd-rom
      8: scanner
      9: optical
      10: jukeBox
      11: commDev
  - name: cpqIdeIdentTypeExtended
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.8
    type: gauge
    help: IDE Extended Device Type - 1.3.6.1.4.1.232.14.2.2.1.1.8
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
    enum_values:
      1: other
      2: pdcd
      3: removableDisk
  - name: cpqIdeIdentCondition2
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.9
    type: gauge
    help: IDE Drive Condition - 1.3.6.1.4.1.232.14.2.2.1.1.9
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqIdeIdentStatus
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.10
    type: gauge
    help: IDE Drive Satus - 1.3.6.1.4.1.232.14.2.2.1.1.10
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: preFailureDegraded
      4: ultraAtaDegraded
  - name: cpqIdeIdentUltraAtaAvailability
    oid: 1.3.6.1.4.1.232.14.2.2.1.1.11
    type: gauge
    help: This describes the availability of Ultra ATA transfers between this device
      and the controller - 1.3.6.1.4.1.232.14.2.2.1.1.11
    indexes:
    - labelname: cpqIdeIdentIndex
      type: gauge
    enum_values:
      1: other
      2: noNotSupportedByDeviceAndController
      3: noNotSupportedByDevice
      4: noNotSupportedByController
      5: noDisabledInSetup
      6: yesEnabledInSetup
  - name: cpqIdeControllerIndex
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.1
    type: gauge
    help: An index that uniquely identifies each controller. - 1.3.6.1.4.1.232.14.2.3.1.1.1
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
  - name: cpqIdeControllerOverallCondition
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.2
    type: gauge
    help: IDE Controller Overall Condition - 1.3.6.1.4.1.232.14.2.3.1.1.2
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqIdeControllerModel
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.3
    type: DisplayString
    help: IDE Controller Model - 1.3.6.1.4.1.232.14.2.3.1.1.3
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
  - name: cpqIdeControllerFwRev
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.4
    type: DisplayString
    help: IDE Controller Firmware Revision - 1.3.6.1.4.1.232.14.2.3.1.1.4
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
  - name: cpqIdeControllerSlot
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.5
    type: gauge
    help: IDE Controller Slot - 1.3.6.1.4.1.232.14.2.3.1.1.5
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
  - name: cpqIdeControllerStatus
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.6
    type: gauge
    help: IDE Channel Host Controller Status - 1.3.6.1.4.1.232.14.2.3.1.1.6
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: failed
  - name: cpqIdeControllerCondition
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.7
    type: gauge
    help: IDE Controller Condition - 1.3.6.1.4.1.232.14.2.3.1.1.7
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqIdeControllerSerialNumber
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.8
    type: DisplayString
    help: IDE Controller Serial Number - 1.3.6.1.4.1.232.14.2.3.1.1.8
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
  - name: cpqIdeControllerHwLocation
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.9
    type: DisplayString
    help: IDE Controller Hardware Location - 1.3.6.1.4.1.232.14.2.3.1.1.9
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
  - name: cpqIdeControllerPciLocation
    oid: 1.3.6.1.4.1.232.14.2.3.1.1.10
    type: DisplayString
    help: IDE Controller PCI Location - 1.3.6.1.4.1.232.14.2.3.1.1.10
    indexes:
    - labelname: cpqIdeControllerIndex
      type: gauge
  - name: cpqIdeAtaDiskControllerIndex
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.1
    type: gauge
    help: An index that uniquely identifies each controller. - 1.3.6.1.4.1.232.14.2.4.1.1.1
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskIndex
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.2
    type: gauge
    help: An index that uniquely identifies each disk. - 1.3.6.1.4.1.232.14.2.4.1.1.2
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskModel
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.3
    type: DisplayString
    help: ATA Disk Model - 1.3.6.1.4.1.232.14.2.4.1.1.3
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskFwRev
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.4
    type: DisplayString
    help: ATA Disk Firmware Revision - 1.3.6.1.4.1.232.14.2.4.1.1.4
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskSerialNumber
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.5
    type: DisplayString
    help: ATA Disk Serial Number - 1.3.6.1.4.1.232.14.2.4.1.1.5
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskStatus
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.6
    type: gauge
    help: ATA Disk Status - 1.3.6.1.4.1.232.14.2.4.1.1.6
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: smartError
      4: failed
      5: ssdWearOut
      6: removed
      7: inserted
  - name: cpqIdeAtaDiskCondition
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.7
    type: gauge
    help: ATA Disk Condition - 1.3.6.1.4.1.232.14.2.4.1.1.7
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqIdeAtaDiskCapacity
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.8
    type: gauge
    help: ATA Disk Capacity - 1.3.6.1.4.1.232.14.2.4.1.1.8
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskSmartEnabled
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.9
    type: gauge
    help: ATA Disk S.M.A.R.T Enabled? other(1) The agent cannot determine the state
      of S.M.A.R.T - 1.3.6.1.4.1.232.14.2.4.1.1.9
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: "true"
      3: "false"
  - name: cpqIdeAtaDiskTransferMode
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.10
    type: gauge
    help: ATA Disk Transfer Mode - 1.3.6.1.4.1.232.14.2.4.1.1.10
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: pioMode0
      3: pioMode1
      4: pioMode2
      5: pioMode3
      6: pioMode4
      7: dmaMode0
      8: dmaMode1
      9: dmaMode2
      10: ultraDmaMode0
      11: ultraDmaMode1
      12: ultraDmaMode2
      13: ultraDmaMode3
      14: ultraDmaMode4
      15: ultraDmaMode5
  - name: cpqIdeAtaDiskChannel
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.11
    type: gauge
    help: ATA Disk Channel - 1.3.6.1.4.1.232.14.2.4.1.1.11
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: channel0
      3: channel1
      4: serial
  - name: cpqIdeAtaDiskNumber
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.12
    type: gauge
    help: ATA Disk Number - 1.3.6.1.4.1.232.14.2.4.1.1.12
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: device0
      3: device1
      4: sataDevice0
      5: sataDevice1
      6: sataDevice2
      7: sataDevice3
      8: sataDevice4
      9: sataDevice5
      10: sataDevice6
      11: sataDevice7
      12: sataDevice8
      13: sataDevice9
      14: sataDevice10
      15: sataDevice11
      16: sataDevice12
      17: sataDevice13
      18: sataDevice14
      19: sataDevice15
      20: sataDevice16
      21: bay1
      22: bay2
      23: bay3
      24: bay4
      25: bay5
      26: bay6
      27: bay7
      28: bay8
      29: bay9
      30: bay10
      31: bay11
      32: bay12
      33: bay13
      34: bay14
      35: bay15
      36: bay16
      37: bay17
      38: bay18
      39: bay19
      40: bay20
      41: bay21
      42: bay22
      43: bay23
      44: bay24
  - name: cpqIdeAtaDiskLogicalDriveMember
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.13
    type: gauge
    help: Logical Drive Membership? other(1) The agent cannot determine if the ATA
      disk is part of a logical drive - 1.3.6.1.4.1.232.14.2.4.1.1.13
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: "true"
      3: "false"
  - name: cpqIdeAtaDiskIsSpare
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.14
    type: gauge
    help: ATA Disk Spare? other(1) The agent cannot determine if the ATA disk is a
      spare - 1.3.6.1.4.1.232.14.2.4.1.1.14
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: "true"
      3: "false"
  - name: cpqIdeAtaDiskOsName
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.15
    type: DisplayString
    help: ATA Disk OS Name - 1.3.6.1.4.1.232.14.2.4.1.1.15
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskType
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.16
    type: gauge
    help: ATA Disk Type other(1) The agent cannot determine the disk type - 1.3.6.1.4.1.232.14.2.4.1.1.16
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: ata
      3: sata
  - name: cpqIdeAtaDiskSataVersion
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.17
    type: gauge
    help: Physical Drive SATA Version - 1.3.6.1.4.1.232.14.2.4.1.1.17
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: sataOne
      3: sataTwo
  - name: cpqIdeAtaDiskMediaType
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.18
    type: gauge
    help: SATA Physical Drive Media Type - 1.3.6.1.4.1.232.14.2.4.1.1.18
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: rotatingPlatters
      3: solidState
  - name: cpqIdeAtaDiskSSDWearStatus
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.19
    type: gauge
    help: SATA Physical Drive Solid State Disk Wear Status - 1.3.6.1.4.1.232.14.2.4.1.1.19
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: fiftySixDayThreshold
      4: fivePercentThreshold
      5: twoPercentThreshold
      6: ssdWearOut
  - name: cpqIdeAtaDiskPowerOnHours
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.20
    type: counter
    help: SATA Physical Drive Power On Hours - 1.3.6.1.4.1.232.14.2.4.1.1.20
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskSSDPercntEndrnceUsed
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.21
    type: gauge
    help: SATA Physical Drive Solid State Percent Endurance Used - 1.3.6.1.4.1.232.14.2.4.1.1.21
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskSSDEstTimeRemainingHours
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.22
    type: counter
    help: SATA Physical Drive Solid State Estimated Time Remaining In Hours - 1.3.6.1.4.1.232.14.2.4.1.1.22
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskCurrTemperature
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.23
    type: gauge
    help: SATA Physical Drive Current Operating Temperature degrees Celsius - 1.3.6.1.4.1.232.14.2.4.1.1.23
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskTemperatureThreshold
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.24
    type: gauge
    help: SATA Physical Drive Maximum Operating Temperature in degrees Celsius - 1.3.6.1.4.1.232.14.2.4.1.1.24
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskMaximumOperatingTemp
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.25
    type: gauge
    help: SATA Physical Drive Maximum Operating Temperature, as specified by the manufacturer,
      in degrees Celsius - 1.3.6.1.4.1.232.14.2.4.1.1.25
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskDestructiveOperatingTemp
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.26
    type: gauge
    help: SATA Physical Drive Destructive Operating Temperature, as specified by the
      manufacturer, in degrees Celsius, which if exceeded can cause damage to the
      drive - 1.3.6.1.4.1.232.14.2.4.1.1.26
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskLocation
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.27
    type: DisplayString
    help: Location of Disk Drive - 1.3.6.1.4.1.232.14.2.4.1.1.27
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskCapacityHighBytes
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.28
    type: counter
    help: ATA Disk Capacity in Bytes (high) - 1.3.6.1.4.1.232.14.2.4.1.1.28
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaDiskCapacityLowBytes
    oid: 1.3.6.1.4.1.232.14.2.4.1.1.29
    type: counter
    help: ATA Disk Capacity in Bytes (low) - 1.3.6.1.4.1.232.14.2.4.1.1.29
    indexes:
    - labelname: cpqIdeAtaDiskControllerIndex
      type: gauge
    - labelname: cpqIdeAtaDiskIndex
      type: gauge
  - name: cpqIdeAtaEraseFailureType
    oid: 1.3.6.1.4.1.232.14.2.4.2
    type: gauge
    help: The value specifies the secure erase status of SATA drive - 1.3.6.1.4.1.232.14.2.4.2
    enum_values:
      1: secureEraseFailed
      2: secureEraseNotSupported
      3: noEraseSupported
  - name: cpqIdeAtapiDeviceControllerIndex
    oid: 1.3.6.1.4.1.232.14.2.5.1.1.1
    type: gauge
    help: An index that uniquely identifies each controller. - 1.3.6.1.4.1.232.14.2.5.1.1.1
    indexes:
    - labelname: cpqIdeAtapiDeviceControllerIndex
      type: gauge
    - labelname: cpqIdeAtapiDeviceIndex
      type: gauge
  - name: cpqIdeAtapiDeviceIndex
    oid: 1.3.6.1.4.1.232.14.2.5.1.1.2
    type: gauge
    help: An index that uniquely identifies each ATAPI device. - 1.3.6.1.4.1.232.14.2.5.1.1.2
    indexes:
    - labelname: cpqIdeAtapiDeviceControllerIndex
      type: gauge
    - labelname: cpqIdeAtapiDeviceIndex
      type: gauge
  - name: cpqIdeAtapiDeviceModel
    oid: 1.3.6.1.4.1.232.14.2.5.1.1.3
    type: DisplayString
    help: ATAPI Device Model - 1.3.6.1.4.1.232.14.2.5.1.1.3
    indexes:
    - labelname: cpqIdeAtapiDeviceControllerIndex
      type: gauge
    - labelname: cpqIdeAtapiDeviceIndex
      type: gauge
  - name: cpqIdeAtapiDeviceFwRev
    oid: 1.3.6.1.4.1.232.14.2.5.1.1.4
    type: DisplayString
    help: ATAPI Device Firmware Revision - 1.3.6.1.4.1.232.14.2.5.1.1.4
    indexes:
    - labelname: cpqIdeAtapiDeviceControllerIndex
      type: gauge
    - labelname: cpqIdeAtapiDeviceIndex
      type: gauge
  - name: cpqIdeAtapiDeviceType
    oid: 1.3.6.1.4.1.232.14.2.5.1.1.5
    type: gauge
    help: ATAPI Device Type - 1.3.6.1.4.1.232.14.2.5.1.1.5
    indexes:
    - labelname: cpqIdeAtapiDeviceControllerIndex
      type: gauge
    - labelname: cpqIdeAtapiDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: disk
      3: tape
      4: printer
      5: processor
      6: wormDrive
      7: cd-rom
      8: scanner
      9: optical
      10: jukeBox
      11: commDev
  - name: cpqIdeAtapiDeviceTypeExtended
    oid: 1.3.6.1.4.1.232.14.2.5.1.1.6
    type: gauge
    help: ATAPI Extended Device Type - 1.3.6.1.4.1.232.14.2.5.1.1.6
    indexes:
    - labelname: cpqIdeAtapiDeviceControllerIndex
      type: gauge
    - labelname: cpqIdeAtapiDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: pdcd
      3: removableDisk
  - name: cpqIdeAtapiDeviceChannel
    oid: 1.3.6.1.4.1.232.14.2.5.1.1.7
    type: gauge
    help: ATAPI Device Channel - 1.3.6.1.4.1.232.14.2.5.1.1.7
    indexes:
    - labelname: cpqIdeAtapiDeviceControllerIndex
      type: gauge
    - labelname: cpqIdeAtapiDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: channel0
      3: channel1
  - name: cpqIdeAtapiDeviceNumber
    oid: 1.3.6.1.4.1.232.14.2.5.1.1.8
    type: gauge
    help: ATAPI Device Number - 1.3.6.1.4.1.232.14.2.5.1.1.8
    indexes:
    - labelname: cpqIdeAtapiDeviceControllerIndex
      type: gauge
    - labelname: cpqIdeAtapiDeviceIndex
      type: gauge
    enum_values:
      1: other
      2: device0
      3: device1
  - name: cpqIdeLogicalDriveControllerIndex
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.1
    type: gauge
    help: An index that uniquely identifies each controller. - 1.3.6.1.4.1.232.14.2.6.1.1.1
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
  - name: cpqIdeLogicalDriveIndex
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.2
    type: gauge
    help: An index that uniquely identifies each logical drive. - 1.3.6.1.4.1.232.14.2.6.1.1.2
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
  - name: cpqIdeLogicalDriveRaidLevel
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.3
    type: gauge
    help: IDE Logical Drive RAID Level - 1.3.6.1.4.1.232.14.2.6.1.1.3
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
    enum_values:
      1: other
      2: raid0
      3: raid1
      4: raid0plus1
      5: raid5
      6: raid15
      7: volume
  - name: cpqIdeLogicalDriveCapacity
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.4
    type: gauge
    help: IDE Logical Drive Capacity - 1.3.6.1.4.1.232.14.2.6.1.1.4
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
  - name: cpqIdeLogicalDriveStatus
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.5
    type: gauge
    help: IDE Logical Drive Status - 1.3.6.1.4.1.232.14.2.6.1.1.5
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: rebuilding
      5: failed
  - name: cpqIdeLogicalDriveCondition
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.6
    type: gauge
    help: IDE Logical Drive Condition - 1.3.6.1.4.1.232.14.2.6.1.1.6
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqIdeLogicalDriveDiskIds
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.7
    type: OctetString
    help: IDE Logical Drive Disk ID list - 1.3.6.1.4.1.232.14.2.6.1.1.7
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
  - name: cpqIdeLogicalDriveStripeSize
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.8
    type: gauge
    help: IDE Logical Drive Stripe Size - 1.3.6.1.4.1.232.14.2.6.1.1.8
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
  - name: cpqIdeLogicalDriveSpareIds
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.9
    type: OctetString
    help: IDE Logical Drive Spare ID list - 1.3.6.1.4.1.232.14.2.6.1.1.9
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
  - name: cpqIdeLogicalDriveRebuildingDisk
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.10
    type: gauge
    help: IDE Logical Drive Rebuilding Disk - 1.3.6.1.4.1.232.14.2.6.1.1.10
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
  - name: cpqIdeLogicalDriveOsName
    oid: 1.3.6.1.4.1.232.14.2.6.1.1.11
    type: DisplayString
    help: IDE Logical Drive OS Name - 1.3.6.1.4.1.232.14.2.6.1.1.11
    indexes:
    - labelname: cpqIdeLogicalDriveControllerIndex
      type: gauge
    - labelname: cpqIdeLogicalDriveIndex
      type: gauge
  - name: cpqDaCntlrIndex
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.1
    type: gauge
    help: Array Controller Index - 1.3.6.1.4.1.232.3.2.2.1.1.1
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrModel
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.2
    type: gauge
    help: Array Controller Model - 1.3.6.1.4.1.232.3.2.2.1.1.2
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: ida
      3: idaExpansion
      4: ida-2
      5: smart
      6: smart-2e
      7: smart-2p
      8: smart-2sl
      9: smart-3100es
      10: smart-3200
      11: smart-2dh
      12: smart-221
      13: sa-4250es
      14: sa-4200
      15: sa-integrated
      16: sa-431
      17: sa-5300
      18: raidLc2
      19: sa-5i
      20: sa-532
      21: sa-5312
      22: sa-641
      23: sa-642
      24: sa-6400
      25: sa-6400em
      26: sa-6i
      27: sa-generic
      29: sa-p600
      30: sa-p400
      31: sa-e200
      32: sa-e200i
      33: sa-p400i
      34: sa-p800
      35: sa-e500
      36: sa-p700m
      37: sa-p212
      38: sa-p410
      39: sa-p410i
      40: sa-p411
      41: sa-b110i
      42: sa-p712m
      43: sa-p711m
      44: sa-p812
      45: sw-1210m
      46: sa-p220i
      47: sa-p222
      48: sa-p420
      49: sa-p420i
      50: sa-p421
      51: sa-b320i
      52: sa-p822
      53: sa-p721m
      54: sa-b120i
      55: hps-1224
      56: hps-1228
      57: hps-1228m
      58: sa-p822se
      59: hps-1224e
      60: hps-1228e
      61: hps-1228em
      62: sa-p230i
      63: sa-p430i
      64: sa-p430
      65: sa-p431
      66: sa-p731m
      67: sa-p830i
      68: sa-p830
      69: sa-p831
      70: sa-p530
      71: sa-p531
      72: sa-p244br
      73: sa-p246br
      74: sa-p440
      75: sa-p440ar
      76: sa-p441
      77: sa-p741m
      78: sa-p840
      79: sa-p841
      80: sh-h240ar
      81: sh-h244br
      82: sh-h240
      83: sh-h241
      84: sa-b140i
      85: sh-generic
      86: sa-p240nr
      87: sh-h240nr
      88: sa-p840ar
      89: sa-p542d
      90: s100i
      91: e208i-p
      92: e208i-a
      93: e208i-c
      94: e208e-p
      95: p204i-b
      96: p204i-c
      97: p408i-p
      98: p408i-a
      99: p408e-p
      100: p408i-c
      101: p408e-m
      102: p416ie-m
      103: p816i-a
      104: p408i-sb
  - name: cpqDaCntlrFWRev
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.3
    type: DisplayString
    help: Array Controller Firmware Revision - 1.3.6.1.4.1.232.3.2.2.1.1.3
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrStndIntr
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.4
    type: gauge
    help: The status of the Standard Interface - 1.3.6.1.4.1.232.3.2.2.1.1.4
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: primary
      3: secondary
      4: disabled
      5: unavailable
  - name: cpqDaCntlrSlot
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.5
    type: gauge
    help: Array Controller Slot - 1.3.6.1.4.1.232.3.2.2.1.1.5
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrCondition
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.6
    type: gauge
    help: The condition of the device - 1.3.6.1.4.1.232.3.2.2.1.1.6
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqDaCntlrProductRev
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.7
    type: DisplayString
    help: Array Controller Product Revision - 1.3.6.1.4.1.232.3.2.2.1.1.7
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrPartnerSlot
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.8
    type: gauge
    help: Array Controller Partner Slot - 1.3.6.1.4.1.232.3.2.2.1.1.8
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrCurrentRole
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.9
    type: gauge
    help: Array Controller Current Role - 1.3.6.1.4.1.232.3.2.2.1.1.9
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: notDuplexed
      3: active
      4: backup
      5: asymActiveActive
  - name: cpqDaCntlrBoardStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.10
    type: gauge
    help: Array Controller Board Status - 1.3.6.1.4.1.232.3.2.2.1.1.10
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: generalFailure
      4: cableProblem
      5: poweredOff
      6: cacheModuleMissing
      7: degraded
  - name: cpqDaCntlrPartnerBoardStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.11
    type: gauge
    help: Array Controller Partner Board Status - 1.3.6.1.4.1.232.3.2.2.1.1.11
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: generalFailure
      4: cableProblem
      5: poweredOff
  - name: cpqDaCntlrBoardCondition
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.12
    type: gauge
    help: The condition of the device - 1.3.6.1.4.1.232.3.2.2.1.1.12
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqDaCntlrPartnerBoardCondition
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.13
    type: gauge
    help: The condition of the device - 1.3.6.1.4.1.232.3.2.2.1.1.13
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqDaCntlrDriveOwnership
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.14
    type: gauge
    help: Array Controller Drive Ownership - 1.3.6.1.4.1.232.3.2.2.1.1.14
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: owner
      3: notOwner
  - name: cpqDaCntlrSerialNumber
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.15
    type: DisplayString
    help: Array Controller Serial Number - 1.3.6.1.4.1.232.3.2.2.1.1.15
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrRedundancyType
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.16
    type: gauge
    help: Array Controller Redundancy Type - 1.3.6.1.4.1.232.3.2.2.1.1.16
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: notRedundant
      3: driverDuplexing
      4: fwActiveStandby
      5: fwPrimarySecondary
      6: fwActiveActive
  - name: cpqDaCntlrRedundancyError
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.17
    type: gauge
    help: Array Controller Redundancy Error - 1.3.6.1.4.1.232.3.2.2.1.1.17
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: noFailure
      3: noRedundantController
      4: differentHardware
      5: noLink
      6: differentFirmware
      7: differentCache
      8: otherCacheFailure
      9: noDrives
      10: otherNoDrives
      11: unsupportedDrives
      12: expandInProgress
  - name: cpqDaCntlrAccessModuleStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.18
    type: gauge
    help: Array Controller RAID ADG Enabler Module Status - 1.3.6.1.4.1.232.3.2.2.1.1.18
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: notPresent
      4: badSignature
      5: badChecksum
      6: fullyFunctional
      7: upgradeFirmware
  - name: cpqDaCntlrDaughterBoardType
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.19
    type: gauge
    help: Array Controller Daughter Board Type - 1.3.6.1.4.1.232.3.2.2.1.1.19
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: notPresent
      4: scsiBoardPresent
      5: fibreBoardPresent
      6: arrayExpansionModulePresent
  - name: cpqDaCntlrHwLocation
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.20
    type: DisplayString
    help: A text description of the hardware location of the controller - 1.3.6.1.4.1.232.3.2.2.1.1.20
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrNumberOfBuses
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.21
    type: gauge
    help: Array Controller Number of Buses - 1.3.6.1.4.1.232.3.2.2.1.1.21
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrBlinkTime
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.22
    type: counter
    help: Controller Physical Drive Blink Time Count - 1.3.6.1.4.1.232.3.2.2.1.1.22
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrRebuildPriority
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.23
    type: gauge
    help: Array Controller Rebuild Priority - 1.3.6.1.4.1.232.3.2.2.1.1.23
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: low
      3: medium
      4: high
      5: mediumHigh
  - name: cpqDaCntlrExpandPriority
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.24
    type: gauge
    help: Array Controller Expand Priority - 1.3.6.1.4.1.232.3.2.2.1.1.24
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: low
      3: medium
      4: high
  - name: cpqDaCntlrNumberOfInternalPorts
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.25
    type: gauge
    help: Array Controller Number of Internal Ports - 1.3.6.1.4.1.232.3.2.2.1.1.25
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrNumberOfExternalPorts
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.26
    type: gauge
    help: Array Controller Number of External Ports - 1.3.6.1.4.1.232.3.2.2.1.1.26
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrDriveWriteCacheState
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.27
    type: gauge
    help: Array Controller Drive Write Cache State - 1.3.6.1.4.1.232.3.2.2.1.1.27
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: disabled
      3: enabled
  - name: cpqDaCntlrPartnerSerialNumber
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.28
    type: DisplayString
    help: Array Controller Partner Serial Number - 1.3.6.1.4.1.232.3.2.2.1.1.28
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrOptionRomRev
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.29
    type: DisplayString
    help: Array Controller Option ROM Revision - 1.3.6.1.4.1.232.3.2.2.1.1.29
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrHbaFWRev
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.30
    type: DisplayString
    help: Array Controller HBA Firmware Revision - 1.3.6.1.4.1.232.3.2.2.1.1.30
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrHBAModeOptionRomRev
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.31
    type: DisplayString
    help: Array Controller HBA Mode Option Rom Revision - 1.3.6.1.4.1.232.3.2.2.1.1.31
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrCurrentTemp
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.32
    type: gauge
    help: Array Controller Current Temperature - 1.3.6.1.4.1.232.3.2.2.1.1.32
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrLastLockupCode
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.33
    type: gauge
    help: Array Controller Last Lockup Code - 1.3.6.1.4.1.232.3.2.2.1.1.33
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
  - name: cpqDaCntlrEncryptionStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.34
    type: gauge
    help: Array Controller Encryption Status - 1.3.6.1.4.1.232.3.2.2.1.1.34
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: notEnabled
      3: enabledLocalKeyMode
      4: enabledRemoteKeyManagerMode
  - name: cpqDaCntlrASICEncptSelfTestStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.35
    type: gauge
    help: Array Controller ASIC Encryption Self Test Status - 1.3.6.1.4.1.232.3.2.2.1.1.35
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: selfTestsPass
      3: selfTestsFailed
  - name: cpqDaCntlrEncryptCspNvramStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.36
    type: gauge
    help: Array Controller Encryption Critical Security Parameter NVRAM Status - 1.3.6.1.4.1.232.3.2.2.1.1.36
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: detectionFailed
  - name: cpqDaCntlrEncryptCryptoOfficerPwdSetStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.37
    type: gauge
    help: Array Controller Encryption Crypto Officer Password Set Status - 1.3.6.1.4.1.232.3.2.2.1.1.37
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: "false"
      3: "true"
  - name: cpqDaCntlrEncryptCntlrPwdSetStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.38
    type: gauge
    help: Array Controller Encryption Controller Password Set Status - 1.3.6.1.4.1.232.3.2.2.1.1.38
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: "false"
      3: "true"
  - name: cpqDaCntlrEncryptCntlrPwdAvailStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.39
    type: gauge
    help: Array Controller Encryption Controller Password Availability Status - 1.3.6.1.4.1.232.3.2.2.1.1.39
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: passwordMissing
      3: passwordActive
  - name: cpqDaCntlrUnencryptedLogDrvCreationPolicy
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.40
    type: gauge
    help: Array Controller Unencrypted Logical Drive Creation Policy - 1.3.6.1.4.1.232.3.2.2.1.1.40
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: "false"
      3: "true"
  - name: cpqDaCntlrEncryptedLogDrvCreationPolicy
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.41
    type: gauge
    help: Array Controller Encrypted Logical Drive Creation Policy - 1.3.6.1.4.1.232.3.2.2.1.1.41
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: "false"
      3: "true"
  - name: cpqDaCntlrEncryptFWLockStatus
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.42
    type: gauge
    help: Array Controller Encryption Firmware Lock Status - 1.3.6.1.4.1.232.3.2.2.1.1.42
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: "false"
      3: "true"
  - name: cpqDaCntlrOperatingMode
    oid: 1.3.6.1.4.1.232.3.2.2.1.1.43
    type: gauge
    help: Array Controller Operating Mode - 1.3.6.1.4.1.232.3.2.2.1.1.43
    indexes:
    - labelname: cpqDaCntlrIndex
      type: gauge
    enum_values:
      1: other
      2: smartArrayMode
      3: smartHbaMode
      4: mixedMode
  - name: cpqDaLogDrvCntlrIndex
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.1
    type: gauge
    help: Drive Array Logical Drive Controller Index - 1.3.6.1.4.1.232.3.2.3.1.1.1
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvIndex
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.2
    type: gauge
    help: Drive Array Logical Drive Index - 1.3.6.1.4.1.232.3.2.3.1.1.2
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvFaultTol
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.3
    type: gauge
    help: Logical Drive Fault Tolerance - 1.3.6.1.4.1.232.3.2.3.1.1.3
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: none
      3: mirroring
      4: dataGuard
      5: distribDataGuard
      7: advancedDataGuard
      8: raid50
      9: raid60
      10: raid1Adm
      11: raid10Adm
      12: raid10
  - name: cpqDaLogDrvStatus
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.4
    type: gauge
    help: Logical Drive Status - 1.3.6.1.4.1.232.3.2.3.1.1.4
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: failed
      4: unconfigured
      5: recovering
      6: readyForRebuild
      7: rebuilding
      8: wrongDrive
      9: badConnect
      10: overheating
      11: shutdown
      12: expanding
      13: notAvailable
      14: queuedForExpansion
      15: multipathAccessDegraded
      16: erasing
      17: predictiveSpareRebuildReady
      18: rapidParityInitInProgress
      19: rapidParityInitPending
      20: noAccessEncryptedNoCntlrKey
      21: unencryptedToEncryptedInProgress
      22: newLogDrvKeyRekeyInProgress
      23: noAccessEncryptedCntlrEncryptnNotEnbld
      24: unencryptedToEncryptedNotStarted
      25: newLogDrvKeyRekeyRequestReceived
      26: unsupported
      27: offline
      28: sedQualInProgrss
      29: sedQualFailed
  - name: cpqDaLogDrvAutoRel
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.5
    type: gauge
    help: Array Controller Logical Drive Auto-Reliability Delay - 1.3.6.1.4.1.232.3.2.3.1.1.5
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvRebuildBlks
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.6
    type: counter
    help: Logical Drive Rebuild Blocks Remaining - 1.3.6.1.4.1.232.3.2.3.1.1.6
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvHasAccel
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.7
    type: gauge
    help: Logical Drive Has Cache Module Board - 1.3.6.1.4.1.232.3.2.3.1.1.7
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: unavailable
      3: enabled
      4: disabled
  - name: cpqDaLogDrvAvailSpares
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.8
    type: OctetString
    help: Drive Array Logical Drive Available Spares - 1.3.6.1.4.1.232.3.2.3.1.1.8
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvSize
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.9
    type: gauge
    help: Logical Drive Size - 1.3.6.1.4.1.232.3.2.3.1.1.9
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvPhyDrvIDs
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.10
    type: OctetString
    help: Drive Array Logical Drive Physical Drive IDs - 1.3.6.1.4.1.232.3.2.3.1.1.10
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvCondition
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.11
    type: gauge
    help: The Logical Drive condition - 1.3.6.1.4.1.232.3.2.3.1.1.11
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqDaLogDrvPercentRebuild
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.12
    type: gauge
    help: Logical Drive Percent Rebuild - 1.3.6.1.4.1.232.3.2.3.1.1.12
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvStripeSize
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.13
    type: gauge
    help: Logical Drive Stripe Size - 1.3.6.1.4.1.232.3.2.3.1.1.13
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvOsName
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.14
    type: DisplayString
    help: Logical Drive OS Name - 1.3.6.1.4.1.232.3.2.3.1.1.14
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvBlinkTime
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.15
    type: counter
    help: Logical Drive Physical Drive Blink Time Count - 1.3.6.1.4.1.232.3.2.3.1.1.15
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvSpareReplaceMap
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.16
    type: OctetString
    help: Logical Drive Spare To Replacement Drive Map - 1.3.6.1.4.1.232.3.2.3.1.1.16
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvRebuildingPhyDrv
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.17
    type: gauge
    help: Logical Drive Physical Drive Rebuilding Index - 1.3.6.1.4.1.232.3.2.3.1.1.17
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvMultipathAccess
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.18
    type: gauge
    help: Logical Drive Multi-path Access - 1.3.6.1.4.1.232.3.2.3.1.1.18
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: notConfigured
      4: pathRedundant
      5: noRedundantPath
  - name: cpqDaLogDrvNmbrOfParityGroups
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.19
    type: gauge
    help: Logical Drive Number Of Parity Groups - 1.3.6.1.4.1.232.3.2.3.1.1.19
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvSplitMirrorBackupLogDrv
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.20
    type: gauge
    help: Logical Drive Split Mirror Backup Logical Drive - 1.3.6.1.4.1.232.3.2.3.1.1.20
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: isNotBackupLogicalDrive
      3: isBackupLogicalDrive
  - name: cpqDaLogDrvCacheVolAccelAssocType
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.21
    type: gauge
    help: Logical Drive Cache Volume Accelerator Association Type - 1.3.6.1.4.1.232.3.2.3.1.1.21
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: nonMember
      3: logicalDriveMember
      4: cacheVolumeMember
  - name: cpqDaLogDrvCacheVolIndex
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.22
    type: gauge
    help: Logical Drive Cache Volume Index - 1.3.6.1.4.1.232.3.2.3.1.1.22
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvRPIPercentComplete
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.23
    type: gauge
    help: Logical Drive Rapid Parity Initialization Percent Complete - 1.3.6.1.4.1.232.3.2.3.1.1.23
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
  - name: cpqDaLogDrvSSDSmartPathStatus
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.24
    type: gauge
    help: Logical Drive SSD Smart Path Status - 1.3.6.1.4.1.232.3.2.3.1.1.24
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: updateDriver
      3: ssdSmartPathDisabled
      4: ssdSmartPathEnabled
  - name: cpqDaLogDrvEncryptionStatus
    oid: 1.3.6.1.4.1.232.3.2.3.1.1.25
    type: gauge
    help: Logical Drive Encryption Status - 1.3.6.1.4.1.232.3.2.3.1.1.25
    indexes:
    - labelname: cpqDaLogDrvCntlrIndex
      type: gauge
    - labelname: cpqDaLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: encrypted
      3: notEncrypted
  - name: cpqDaPhyDrvCntlrIndex
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.1
    type: gauge
    help: Drive Array Physical Drive Controller Index - 1.3.6.1.4.1.232.3.2.5.1.1.1
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvIndex
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.2
    type: gauge
    help: Drive Array Physical Drive Index - 1.3.6.1.4.1.232.3.2.5.1.1.2
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvModel
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.3
    type: DisplayString
    help: Physical Drive Model - 1.3.6.1.4.1.232.3.2.5.1.1.3
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvFWRev
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.4
    type: DisplayString
    help: Physical Drive Firmware Revision - 1.3.6.1.4.1.232.3.2.5.1.1.4
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvBay
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.5
    type: gauge
    help: Physical Drive Bay Location - 1.3.6.1.4.1.232.3.2.5.1.1.5
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvStatus
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.6
    type: gauge
    help: Physical Drive Status - 1.3.6.1.4.1.232.3.2.5.1.1.6
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: failed
      4: predictiveFailure
      5: erasing
      6: eraseDone
      7: eraseQueued
      8: ssdWearOut
      9: notAuthenticated
  - name: cpqDaPhyDrvFactReallocs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.7
    type: gauge
    help: This shows the number of spare sectors available for remapping at the time
      the physical drive was shipped - 1.3.6.1.4.1.232.3.2.5.1.1.7
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvUsedReallocs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.8
    type: counter
    help: Physical Drive Used Reallocated Sectors - 1.3.6.1.4.1.232.3.2.5.1.1.8
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvRefHours
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.9
    type: counter
    help: Reference Time in hours - 1.3.6.1.4.1.232.3.2.5.1.1.9
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvHReads
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.10
    type: counter
    help: Sectors Read (high) - 1.3.6.1.4.1.232.3.2.5.1.1.10
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvReads
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.11
    type: counter
    help: Sectors Read (low) - 1.3.6.1.4.1.232.3.2.5.1.1.11
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvHWrites
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.12
    type: counter
    help: Sectors Written (high) - 1.3.6.1.4.1.232.3.2.5.1.1.12
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvWrites
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.13
    type: counter
    help: Sectors Written (low) - 1.3.6.1.4.1.232.3.2.5.1.1.13
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvHSeeks
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.14
    type: counter
    help: Total Seeks (high) - 1.3.6.1.4.1.232.3.2.5.1.1.14
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSeeks
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.15
    type: counter
    help: Total Seeks (low) - 1.3.6.1.4.1.232.3.2.5.1.1.15
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvHardReadErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.16
    type: counter
    help: Hard Read Errors - 1.3.6.1.4.1.232.3.2.5.1.1.16
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvRecvReadErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.17
    type: counter
    help: Recovered Read Errors - 1.3.6.1.4.1.232.3.2.5.1.1.17
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvHardWriteErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.18
    type: counter
    help: Hard Write Errors - 1.3.6.1.4.1.232.3.2.5.1.1.18
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvRecvWriteErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.19
    type: counter
    help: Recovered Write Errors - 1.3.6.1.4.1.232.3.2.5.1.1.19
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvHSeekErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.20
    type: counter
    help: Seek Errors (High) - 1.3.6.1.4.1.232.3.2.5.1.1.20
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSeekErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.21
    type: counter
    help: Seek Errors (low) - 1.3.6.1.4.1.232.3.2.5.1.1.21
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSpinupTime
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.22
    type: gauge
    help: Spin up Time in tenths of seconds - 1.3.6.1.4.1.232.3.2.5.1.1.22
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvFunctTest1
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.23
    type: gauge
    help: Functional Test 1 - 1.3.6.1.4.1.232.3.2.5.1.1.23
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvFunctTest2
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.24
    type: gauge
    help: Functional Test 2 - 1.3.6.1.4.1.232.3.2.5.1.1.24
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvFunctTest3
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.25
    type: gauge
    help: Functional Test 3 - 1.3.6.1.4.1.232.3.2.5.1.1.25
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvDrqTimeouts
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.26
    type: counter
    help: DRQ Timeouts - 1.3.6.1.4.1.232.3.2.5.1.1.26
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvOtherTimeouts
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.27
    type: counter
    help: Other Timeouts - 1.3.6.1.4.1.232.3.2.5.1.1.27
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSpinupRetries
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.28
    type: counter
    help: Spin up Retries - 1.3.6.1.4.1.232.3.2.5.1.1.28
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvBadRecvReads
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.29
    type: counter
    help: Recovery Failed (Bad) Read Error - 1.3.6.1.4.1.232.3.2.5.1.1.29
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvBadRecvWrites
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.30
    type: counter
    help: Recovery Failed (Bad) Write Error - 1.3.6.1.4.1.232.3.2.5.1.1.30
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvFormatErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.31
    type: counter
    help: Format Error - 1.3.6.1.4.1.232.3.2.5.1.1.31
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvPostErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.32
    type: counter
    help: Power On Self Test (Post) Error - 1.3.6.1.4.1.232.3.2.5.1.1.32
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvNotReadyErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.33
    type: counter
    help: Drive Not Ready Errors - 1.3.6.1.4.1.232.3.2.5.1.1.33
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvReallocAborts
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.34
    type: counter
    help: Physical Drive Reallocation Aborts - 1.3.6.1.4.1.232.3.2.5.1.1.34
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvThreshPassed
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.35
    type: gauge
    help: Physical Drive Factory Threshold Passed (Exceeded) - 1.3.6.1.4.1.232.3.2.5.1.1.35
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: "false"
      2: "true"
  - name: cpqDaPhyDrvHasMonInfo
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.36
    type: gauge
    help: Physical Drive Has Monitor Information - 1.3.6.1.4.1.232.3.2.5.1.1.36
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: "false"
      2: "true"
  - name: cpqDaPhyDrvCondition
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.37
    type: gauge
    help: The condition of the device - 1.3.6.1.4.1.232.3.2.5.1.1.37
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqDaPhyDrvHotPlugs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.38
    type: counter
    help: Physical Drive Hot Plug Count - 1.3.6.1.4.1.232.3.2.5.1.1.38
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvMediaErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.39
    type: counter
    help: Physical Drive Media Failure Count - 1.3.6.1.4.1.232.3.2.5.1.1.39
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvHardwareErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.40
    type: counter
    help: Physical Drive Hardware Error Count - 1.3.6.1.4.1.232.3.2.5.1.1.40
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvAbortedCmds
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.41
    type: counter
    help: Physical Drive Aborted Command Failures - 1.3.6.1.4.1.232.3.2.5.1.1.41
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSpinUpErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.42
    type: counter
    help: Physical Drive Spin-Up Failure Count - 1.3.6.1.4.1.232.3.2.5.1.1.42
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvBadTargetErrs
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.43
    type: counter
    help: Physical Drive Bad Target Count - 1.3.6.1.4.1.232.3.2.5.1.1.43
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvLocation
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.44
    type: gauge
    help: Drive Physical Location - 1.3.6.1.4.1.232.3.2.5.1.1.44
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: internal
      3: external
      4: proLiant
  - name: cpqDaPhyDrvSize
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.45
    type: gauge
    help: Physical Drive Size in MB - 1.3.6.1.4.1.232.3.2.5.1.1.45
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvBusFaults
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.46
    type: counter
    help: Physical Drive Bus Fault Count - 1.3.6.1.4.1.232.3.2.5.1.1.46
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvIrqDeglitches
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.47
    type: counter
    help: Physical Drive IRQ Deglitch Count - 1.3.6.1.4.1.232.3.2.5.1.1.47
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvHotPlug
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.48
    type: gauge
    help: Physical Drive Hot Plug Support Status - 1.3.6.1.4.1.232.3.2.5.1.1.48
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: hotPlug
      3: nonHotPlug
  - name: cpqDaPhyDrvPlacement
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.49
    type: gauge
    help: Physical Drive Placement - 1.3.6.1.4.1.232.3.2.5.1.1.49
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: internal
      3: external
  - name: cpqDaPhyDrvBusNumber
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.50
    type: gauge
    help: Physical Drive SCSI Bus Number - 1.3.6.1.4.1.232.3.2.5.1.1.50
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSerialNum
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.51
    type: DisplayString
    help: Physical Drive Serial Number - 1.3.6.1.4.1.232.3.2.5.1.1.51
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvPreFailMonitoring
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.52
    type: gauge
    help: Drive Array Physical Drive Predictive Failure Monitoring - 1.3.6.1.4.1.232.3.2.5.1.1.52
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: notAvailable
      3: available
  - name: cpqDaPhyDrvCurrentWidth
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.53
    type: gauge
    help: Drive Array Physical Drive Current Width - 1.3.6.1.4.1.232.3.2.5.1.1.53
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: narrow
      3: wide16
  - name: cpqDaPhyDrvCurrentSpeed
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.54
    type: gauge
    help: Drive Array Physical Drive Current Data Transfer Speed - 1.3.6.1.4.1.232.3.2.5.1.1.54
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: asynchronous
      3: fast
      4: ultra
      5: ultra2
      6: ultra3
      7: ultra320
  - name: cpqDaPhyDrvFailureCode
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.55
    type: gauge
    help: Drive Array Physical Drive Failure Code - 1.3.6.1.4.1.232.3.2.5.1.1.55
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvBlinkTime
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.56
    type: counter
    help: Physical Drive Blink Time Count - 1.3.6.1.4.1.232.3.2.5.1.1.56
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSmartStatus
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.57
    type: gauge
    help: Physical Drive S.M.A.R.T Status - 1.3.6.1.4.1.232.3.2.5.1.1.57
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: replaceDrive
      4: replaceDriveSSDWearOut
  - name: cpqDaPhyDrvConfigurationStatus
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.58
    type: gauge
    help: Physical Drive Configuration Status - 1.3.6.1.4.1.232.3.2.5.1.1.58
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: configured
      3: notConfigured
  - name: cpqDaPhyDrvRotationalSpeed
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.59
    type: gauge
    help: Drive Array Physical Drive Rotational Speed - 1.3.6.1.4.1.232.3.2.5.1.1.59
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: rpm7200
      3: rpm10K
      4: rpm15K
      5: rpmSsd
  - name: cpqDaPhyDrvType
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.60
    type: gauge
    help: Physical Drive Type - 1.3.6.1.4.1.232.3.2.5.1.1.60
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: parallelScsi
      3: sata
      4: sas
      5: nvme
  - name: cpqDaPhyDrvSataVersion
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.61
    type: gauge
    help: Physical Drive SATA Version - 1.3.6.1.4.1.232.3.2.5.1.1.61
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: sataOne
      3: sataTwo
  - name: cpqDaPhyDrvHostConnector
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.62
    type: DisplayString
    help: Physical Drive Host Connector - 1.3.6.1.4.1.232.3.2.5.1.1.62
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvBoxOnConnector
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.63
    type: gauge
    help: Physical Drive Box on Connector - 1.3.6.1.4.1.232.3.2.5.1.1.63
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvLocationString
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.64
    type: DisplayString
    help: Physical Drive Location String - 1.3.6.1.4.1.232.3.2.5.1.1.64
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvNegotiatedLinkRate
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.65
    type: gauge
    help: Drive Array Physical Drive Negotiated Link Rate - 1.3.6.1.4.1.232.3.2.5.1.1.65
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: rate-1-5
      3: rate-3-0
      4: rate-6-0
      5: rate-12-0
  - name: cpqDaPhyDrvNcqSupport
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.66
    type: gauge
    help: Drive Array Physical Drive Native Command Queueing - 1.3.6.1.4.1.232.3.2.5.1.1.66
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: noControllerSupport
      3: noDriveSupport
      4: ncqDisabled
      5: ncqEnabled
  - name: cpqDaPhyDrvPhyCount
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.67
    type: gauge
    help: Drive Array Physical Drive PHY Count - 1.3.6.1.4.1.232.3.2.5.1.1.67
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvMultipathAccess
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.68
    type: gauge
    help: Drive Array Physical Drive Multi-path Access Status - 1.3.6.1.4.1.232.3.2.5.1.1.68
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: notConfigured
      4: pathRedundant
      5: noRedundantPath
      6: driveFailed
  - name: cpqDaPhyDrvMediaType
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.69
    type: gauge
    help: Drive Array Physical Drive Media Type - 1.3.6.1.4.1.232.3.2.5.1.1.69
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: rotatingPlatters
      3: solidState
      4: smr
  - name: cpqDaPhyDrvCurrentTemperature
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.70
    type: gauge
    help: Drive Array Physical Drive Current Temperature - 1.3.6.1.4.1.232.3.2.5.1.1.70
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvTemperatureThreshold
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.71
    type: gauge
    help: Drive Array Physical Drive Temperature Threshold - 1.3.6.1.4.1.232.3.2.5.1.1.71
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvMaximumTemperature
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.72
    type: gauge
    help: Drive Array Physical Drive Maximum Temperature - 1.3.6.1.4.1.232.3.2.5.1.1.72
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSSDWearStatus
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.73
    type: gauge
    help: Drive Array Physical Drive Solid State Disk Wear Status - 1.3.6.1.4.1.232.3.2.5.1.1.73
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: fiftySixDayThreshold
      4: fivePercentThreshold
      5: twoPercentThreshold
      6: ssdWearOut
  - name: cpqDaPhyDrvPowerOnHours
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.74
    type: counter
    help: Drive Array Physical Drive Power On Hours - 1.3.6.1.4.1.232.3.2.5.1.1.74
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSSDPercntEndrnceUsed
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.75
    type: gauge
    help: Drive Array Physical Drive Solid State Percent Endurance Used - 1.3.6.1.4.1.232.3.2.5.1.1.75
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSSDEstTimeRemainingHours
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.76
    type: counter
    help: Drive Array Physical Drive Solid State Estimated Time Remaining In Hours
      - 1.3.6.1.4.1.232.3.2.5.1.1.76
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvAuthenticationStatus
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.77
    type: gauge
    help: Drive Array Physical Drive Authentication Status - 1.3.6.1.4.1.232.3.2.5.1.1.77
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: authenticationFailed
      4: authenticationPassed
  - name: cpqDaPhyDrvSmartCarrierAppFWRev
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.78
    type: gauge
    help: Physical Drive Smart Carrier Application Firmware Revision - 1.3.6.1.4.1.232.3.2.5.1.1.78
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvSmartCarrierBootldrFWRev
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.79
    type: gauge
    help: Physical Drive Smart Carrier Bootloader Firmware Revision - 1.3.6.1.4.1.232.3.2.5.1.1.79
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
  - name: cpqDaPhyDrvEncryptionStatus
    oid: 1.3.6.1.4.1.232.3.2.5.1.1.80
    type: gauge
    help: Physical Drive Encryption Status - 1.3.6.1.4.1.232.3.2.5.1.1.80
    indexes:
    - labelname: cpqDaPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqDaPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: encrypted
      3: notEncrypted
  - name: cpqScsiMibRevMajor
    oid: 1.3.6.1.4.1.232.5.1.1
    type: gauge
    help: The Major Revision level - 1.3.6.1.4.1.232.5.1.1
  - name: cpqScsiMibRevMinor
    oid: 1.3.6.1.4.1.232.5.1.2
    type: gauge
    help: The Minor Revision level - 1.3.6.1.4.1.232.5.1.2
  - name: cpqScsiMibCondition
    oid: 1.3.6.1.4.1.232.5.1.3
    type: gauge
    help: The overall condition - 1.3.6.1.4.1.232.5.1.3
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqScsiNw3xDriverName
    oid: 1.3.6.1.4.1.232.5.2.1.1.1
    type: DisplayString
    help: SCSI Drive Device Driver Name - 1.3.6.1.4.1.232.5.2.1.1.1
  - name: cpqScsiNw3xDriverVers
    oid: 1.3.6.1.4.1.232.5.2.1.1.2
    type: DisplayString
    help: SCSI Drive Device Driver Version - 1.3.6.1.4.1.232.5.2.1.1.2
  - name: cpqScsiNw3xDriverPollType
    oid: 1.3.6.1.4.1.232.5.2.1.1.3
    type: gauge
    help: SCSI Drive Device Driver Poll Type - 1.3.6.1.4.1.232.5.2.1.1.3
    enum_values:
      1: other
      2: polled
      3: demand
  - name: cpqScsiNw3xDriverPollTime
    oid: 1.3.6.1.4.1.232.5.2.1.1.4
    type: gauge
    help: SCSI Drive Device Driver Poll Time - 1.3.6.1.4.1.232.5.2.1.1.4
  - name: cpqScsiNw3xCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.1.1.5.1.1
    type: gauge
    help: SCSI Controller Index - 1.3.6.1.4.1.232.5.2.1.1.5.1.1
    indexes:
    - labelname: cpqScsiNw3xCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xBusIndex
      type: gauge
  - name: cpqScsiNw3xBusIndex
    oid: 1.3.6.1.4.1.232.5.2.1.1.5.1.2
    type: gauge
    help: SCSI Bus Index - 1.3.6.1.4.1.232.5.2.1.1.5.1.2
    indexes:
    - labelname: cpqScsiNw3xCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xBusIndex
      type: gauge
  - name: cpqScsiNw3xXptDesc
    oid: 1.3.6.1.4.1.232.5.2.1.1.5.1.3
    type: DisplayString
    help: SCSI XPT Description - 1.3.6.1.4.1.232.5.2.1.1.5.1.3
    indexes:
    - labelname: cpqScsiNw3xCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xBusIndex
      type: gauge
  - name: cpqScsiNw3xXptVers
    oid: 1.3.6.1.4.1.232.5.2.1.1.5.1.4
    type: DisplayString
    help: SCSI XPT Version - 1.3.6.1.4.1.232.5.2.1.1.5.1.4
    indexes:
    - labelname: cpqScsiNw3xCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xBusIndex
      type: gauge
  - name: cpqScsiNw3xSimDesc
    oid: 1.3.6.1.4.1.232.5.2.1.1.5.1.5
    type: DisplayString
    help: SCSI SIM Description - 1.3.6.1.4.1.232.5.2.1.1.5.1.5
    indexes:
    - labelname: cpqScsiNw3xCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xBusIndex
      type: gauge
  - name: cpqScsiNw3xSimVers
    oid: 1.3.6.1.4.1.232.5.2.1.1.5.1.6
    type: DisplayString
    help: SCSI SIM Version - 1.3.6.1.4.1.232.5.2.1.1.5.1.6
    indexes:
    - labelname: cpqScsiNw3xCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xBusIndex
      type: gauge
  - name: cpqScsiNw3xHbaDesc
    oid: 1.3.6.1.4.1.232.5.2.1.1.5.1.7
    type: DisplayString
    help: SCSI HBA Description - 1.3.6.1.4.1.232.5.2.1.1.5.1.7
    indexes:
    - labelname: cpqScsiNw3xCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xBusIndex
      type: gauge
  - name: cpqScsiNw3xStatCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.1
    type: gauge
    help: SCSI Controller Index - 1.3.6.1.4.1.232.5.2.1.1.6.1.1
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xStatBusIndex
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.2
    type: gauge
    help: SCSI Bus Index - 1.3.6.1.4.1.232.5.2.1.1.6.1.2
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xStatLogDrvIndex
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.3
    type: gauge
    help: SCSI Logical Drive Index - 1.3.6.1.4.1.232.5.2.1.1.6.1.3
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xTotalReads
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.4
    type: counter
    help: SCSI Logical Drive Total Reads - 1.3.6.1.4.1.232.5.2.1.1.6.1.4
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xTotalWrites
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.5
    type: counter
    help: SCSI Logical Drive Total Writes - 1.3.6.1.4.1.232.5.2.1.1.6.1.5
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xCorrReads
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.6
    type: counter
    help: SCSI Logical Drive Corrected Reads - 1.3.6.1.4.1.232.5.2.1.1.6.1.6
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xCorrWrites
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.7
    type: counter
    help: SCSI Logical Drive Corrected Writes - 1.3.6.1.4.1.232.5.2.1.1.6.1.7
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xFatalReads
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.8
    type: counter
    help: SCSI Logical Drive Fatal Reads - 1.3.6.1.4.1.232.5.2.1.1.6.1.8
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xFatalWrites
    oid: 1.3.6.1.4.1.232.5.2.1.1.6.1.9
    type: counter
    help: SCSI Logical Drive Fatal Writes - 1.3.6.1.4.1.232.5.2.1.1.6.1.9
    indexes:
    - labelname: cpqScsiNw3xStatCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xStatBusIndex
      type: gauge
    - labelname: cpqScsiNw3xStatLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xVolCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.1.1.7.1.1
    type: gauge
    help: SCSI Cntlr Index - 1.3.6.1.4.1.232.5.2.1.1.7.1.1
    indexes:
    - labelname: cpqScsiNw3xVolCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xVolBusIndex
      type: gauge
    - labelname: cpqScsiNw3xVolLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xVolBusIndex
    oid: 1.3.6.1.4.1.232.5.2.1.1.7.1.2
    type: gauge
    help: SCSI Bus Index - 1.3.6.1.4.1.232.5.2.1.1.7.1.2
    indexes:
    - labelname: cpqScsiNw3xVolCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xVolBusIndex
      type: gauge
    - labelname: cpqScsiNw3xVolLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xVolLogDrvIndex
    oid: 1.3.6.1.4.1.232.5.2.1.1.7.1.3
    type: gauge
    help: SCSI Logical Drive Index - 1.3.6.1.4.1.232.5.2.1.1.7.1.3
    indexes:
    - labelname: cpqScsiNw3xVolCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xVolBusIndex
      type: gauge
    - labelname: cpqScsiNw3xVolLogDrvIndex
      type: gauge
  - name: cpqScsiNw3xVolMap
    oid: 1.3.6.1.4.1.232.5.2.1.1.7.1.4
    type: OctetString
    help: SCSI Drive Volume Map - 1.3.6.1.4.1.232.5.2.1.1.7.1.4
    indexes:
    - labelname: cpqScsiNw3xVolCntlrIndex
      type: gauge
    - labelname: cpqScsiNw3xVolBusIndex
      type: gauge
    - labelname: cpqScsiNw3xVolLogDrvIndex
      type: gauge
  - name: cpqScsiOsCommonPollFreq
    oid: 1.3.6.1.4.1.232.5.2.1.4.1
    type: gauge
    help: The agent`s polling frequency - 1.3.6.1.4.1.232.5.2.1.4.1
  - name: cpqScsiOsCommonModuleIndex
    oid: 1.3.6.1.4.1.232.5.2.1.4.2.1.1
    type: gauge
    help: A unique index for this module description. - 1.3.6.1.4.1.232.5.2.1.4.2.1.1
    indexes:
    - labelname: cpqScsiOsCommonModuleIndex
      type: gauge
  - name: cpqScsiOsCommonModuleName
    oid: 1.3.6.1.4.1.232.5.2.1.4.2.1.2
    type: DisplayString
    help: The module name. - 1.3.6.1.4.1.232.5.2.1.4.2.1.2
    indexes:
    - labelname: cpqScsiOsCommonModuleIndex
      type: gauge
  - name: cpqScsiOsCommonModuleVersion
    oid: 1.3.6.1.4.1.232.5.2.1.4.2.1.3
    type: DisplayString
    help: The module version in XX.YY format - 1.3.6.1.4.1.232.5.2.1.4.2.1.3
    indexes:
    - labelname: cpqScsiOsCommonModuleIndex
      type: gauge
  - name: cpqScsiOsCommonModuleDate
    oid: 1.3.6.1.4.1.232.5.2.1.4.2.1.4
    type: OctetString
    help: The module date - 1.3.6.1.4.1.232.5.2.1.4.2.1.4
    indexes:
    - labelname: cpqScsiOsCommonModuleIndex
      type: gauge
  - name: cpqScsiOsCommonModulePurpose
    oid: 1.3.6.1.4.1.232.5.2.1.4.2.1.5
    type: DisplayString
    help: The purpose of the module described in this entry. - 1.3.6.1.4.1.232.5.2.1.4.2.1.5
    indexes:
    - labelname: cpqScsiOsCommonModuleIndex
      type: gauge
  - name: cpqScsiCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.1
    type: gauge
    help: SCSI Controller Index - 1.3.6.1.4.1.232.5.2.2.1.1.1
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrBusIndex
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.2
    type: gauge
    help: SCSI Bus Index - 1.3.6.1.4.1.232.5.2.2.1.1.2
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrModel
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.3
    type: gauge
    help: SCSI Controller Model - 1.3.6.1.4.1.232.5.2.2.1.1.3
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
    enum_values:
      1: other
      2: cpqs710
      3: cpqs94
      4: cpqs810p
      5: cpqs825e
      6: cpqs825p
      7: cpqs974p
      8: cpqs875p
      9: extended
      10: cpqs895p
      11: cpqs896p
      12: cpqa789x
      13: cpqs876t
      14: hpu320
      15: hpu320r
      16: generic
      17: hp1u320g2
      18: hp1u320g1
      19: hpSc11Xe
  - name: cpqScsiCntlrFWVers
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.4
    type: DisplayString
    help: SCSI Controller Firmware Version - 1.3.6.1.4.1.232.5.2.2.1.1.4
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrSWVers
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.5
    type: DisplayString
    help: SCSI Controller Software Version - 1.3.6.1.4.1.232.5.2.2.1.1.5
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrSlot
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.6
    type: gauge
    help: SCSI Controller Slot - 1.3.6.1.4.1.232.5.2.2.1.1.6
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrStatus
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.7
    type: gauge
    help: SCSI Controller Status - 1.3.6.1.4.1.232.5.2.2.1.1.7
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: failed
  - name: cpqScsiCntlrHardResets
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.8
    type: counter
    help: SCSI Controller Hard Resets - 1.3.6.1.4.1.232.5.2.2.1.1.8
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrSoftResets
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.9
    type: counter
    help: SCSI Controller Soft Resets - 1.3.6.1.4.1.232.5.2.2.1.1.9
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrTimeouts
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.10
    type: counter
    help: SCSI Controller Time-outs - 1.3.6.1.4.1.232.5.2.2.1.1.10
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrBaseIOAddr
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.11
    type: gauge
    help: SCSI Controller Base I/O Address - 1.3.6.1.4.1.232.5.2.2.1.1.11
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrCondition
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.12
    type: gauge
    help: SCSI Controller Condition - 1.3.6.1.4.1.232.5.2.2.1.1.12
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqScsiCntlrSerialNum
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.13
    type: DisplayString
    help: SCSI Controller Serial Number - 1.3.6.1.4.1.232.5.2.2.1.1.13
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrBusWidth
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.14
    type: gauge
    help: SCSI Controller Data Bus Width - 1.3.6.1.4.1.232.5.2.2.1.1.14
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
    enum_values:
      1: other
      2: narrow
      3: wide16
  - name: cpqScsiCntlrModelExtended
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.15
    type: DisplayString
    help: SCSI Controller Model Name - 1.3.6.1.4.1.232.5.2.2.1.1.15
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrHwLocation
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.16
    type: DisplayString
    help: A text description of the hardware location, on complex multi SBB hardware
      only, for the SCSI controller - 1.3.6.1.4.1.232.5.2.2.1.1.16
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiCntlrPciLocation
    oid: 1.3.6.1.4.1.232.5.2.2.1.1.17
    type: DisplayString
    help: A string designating the PCI device location for the controller, following
      the format DDDD:BB:DD.F, where DDDD is the PCI domain number, BB is the PCI
      bus number, DD is the PCI device number, and F is the PCI function number -
      1.3.6.1.4.1.232.5.2.2.1.1.17
    indexes:
    - labelname: cpqScsiCntlrIndex
      type: gauge
    - labelname: cpqScsiCntlrBusIndex
      type: gauge
  - name: cpqScsiLogDrvCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.1
    type: gauge
    help: SCSI Logical Drive Controller Index - 1.3.6.1.4.1.232.5.2.3.1.1.1
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiLogDrvBusIndex
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.2
    type: gauge
    help: SCSI Logical Drive Bus Index - 1.3.6.1.4.1.232.5.2.3.1.1.2
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiLogDrvIndex
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.3
    type: gauge
    help: SCSI Logical Drive Index - 1.3.6.1.4.1.232.5.2.3.1.1.3
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiLogDrvFaultTol
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.4
    type: gauge
    help: SCSI Logical Drive Fault Tolerance - 1.3.6.1.4.1.232.5.2.3.1.1.4
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: none
      3: mirroring
      4: dataGuard
      5: distribDataGuard
      6: enhancedMirroring
  - name: cpqScsiLogDrvStatus
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.5
    type: gauge
    help: SCSI Logical Drive Status - 1.3.6.1.4.1.232.5.2.3.1.1.5
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: failed
      4: unconfigured
      5: recovering
      6: readyForRebuild
      7: rebuilding
      8: wrongDrive
      9: badConnect
      10: degraded
      11: disabled
  - name: cpqScsiLogDrvSize
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.6
    type: gauge
    help: SCSI Logical Drive Size - 1.3.6.1.4.1.232.5.2.3.1.1.6
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiLogDrvPhyDrvIDs
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.7
    type: OctetString
    help: SCSI Logical Drive Physical Drive IDs - 1.3.6.1.4.1.232.5.2.3.1.1.7
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiLogDrvCondition
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.8
    type: gauge
    help: SCSI Logical Drive Condition - 1.3.6.1.4.1.232.5.2.3.1.1.8
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqScsiLogDrvStripeSize
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.9
    type: gauge
    help: Logical Drive Stripe Size - 1.3.6.1.4.1.232.5.2.3.1.1.9
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiLogDrvAvailSpares
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.10
    type: OctetString
    help: SCSI Logical Drive Available Spares - 1.3.6.1.4.1.232.5.2.3.1.1.10
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiLogDrvPercentRebuild
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.11
    type: gauge
    help: Logical Drive Percent Rebuild - 1.3.6.1.4.1.232.5.2.3.1.1.11
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiLogDrvOsName
    oid: 1.3.6.1.4.1.232.5.2.3.1.1.12
    type: DisplayString
    help: Logical Drive OS Name - 1.3.6.1.4.1.232.5.2.3.1.1.12
    indexes:
    - labelname: cpqScsiLogDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiLogDrvBusIndex
      type: gauge
    - labelname: cpqScsiLogDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.1
    type: gauge
    help: SCSI Physical Drive Controller Index - 1.3.6.1.4.1.232.5.2.4.1.1.1
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvBusIndex
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.2
    type: gauge
    help: SCSI Physical Drive Bus Index - 1.3.6.1.4.1.232.5.2.4.1.1.2
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvIndex
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.3
    type: gauge
    help: SCSI Physical Drive Index - 1.3.6.1.4.1.232.5.2.4.1.1.3
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvModel
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.4
    type: DisplayString
    help: SCSI Physical Drive Model - 1.3.6.1.4.1.232.5.2.4.1.1.4
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvFWRev
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.5
    type: DisplayString
    help: SCSI Physical Drive Firmware Revision - 1.3.6.1.4.1.232.5.2.4.1.1.5
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvVendor
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.6
    type: DisplayString
    help: SCSI Physical Drive Vendor - 1.3.6.1.4.1.232.5.2.4.1.1.6
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvSize
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.7
    type: gauge
    help: SCSI Physical Drive Size in MB - 1.3.6.1.4.1.232.5.2.4.1.1.7
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvScsiID
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.8
    type: gauge
    help: SCSI Physical Drive SCSI ID - 1.3.6.1.4.1.232.5.2.4.1.1.8
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvStatus
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.9
    type: gauge
    help: SCSI Physical Drive Status - 1.3.6.1.4.1.232.5.2.4.1.1.9
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: failed
      4: notConfigured
      5: badCable
      6: missingWasOk
      7: missingWasFailed
      8: predictiveFailure
      9: missingWasPredictiveFailure
      10: offline
      11: missingWasOffline
      12: hardError
  - name: cpqScsiPhyDrvServiceHours
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.10
    type: counter
    help: SCSI Physical Drive Service Time in hours - 1.3.6.1.4.1.232.5.2.4.1.1.10
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvHighReadSectors
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.11
    type: counter
    help: SCSI Physical Drive Sectors Read (high) - 1.3.6.1.4.1.232.5.2.4.1.1.11
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvLowReadSectors
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.12
    type: counter
    help: SCSI Physical Drive Sectors Read (low) - 1.3.6.1.4.1.232.5.2.4.1.1.12
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvHighWriteSectors
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.13
    type: counter
    help: SCSI Physical Drive Sectors Written (high) - 1.3.6.1.4.1.232.5.2.4.1.1.13
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvLowWriteSectors
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.14
    type: counter
    help: SCSI Physical Drive Sectors Written (low) - 1.3.6.1.4.1.232.5.2.4.1.1.14
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvHardReadErrs
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.15
    type: counter
    help: SCSI Physical Drive Hard Read Errors - 1.3.6.1.4.1.232.5.2.4.1.1.15
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvHardWriteErrs
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.16
    type: counter
    help: SCSI Physical Drive Hard Write Errors - 1.3.6.1.4.1.232.5.2.4.1.1.16
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvEccCorrReads
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.17
    type: counter
    help: SCSI Physical Drive ECC Corrected Read Errors (high) - 1.3.6.1.4.1.232.5.2.4.1.1.17
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvRecvReadErrs
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.18
    type: counter
    help: SCSI Physical Drive Recovered Read Errors - 1.3.6.1.4.1.232.5.2.4.1.1.18
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvRecvWriteErrs
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.19
    type: counter
    help: SCSI Physical Drive Recovered Write Errors - 1.3.6.1.4.1.232.5.2.4.1.1.19
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvSeekErrs
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.20
    type: counter
    help: SCSI Physical Drive Seek Errors - 1.3.6.1.4.1.232.5.2.4.1.1.20
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvSpinupTime
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.21
    type: gauge
    help: SCSI Physical Drive Spin up Time (tenths of seconds) - 1.3.6.1.4.1.232.5.2.4.1.1.21
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvUsedReallocs
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.22
    type: counter
    help: SCSI Physical Drive Used Reallocation Sectors - 1.3.6.1.4.1.232.5.2.4.1.1.22
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvTimeouts
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.23
    type: counter
    help: SCSI Physical Drive Time-out Errors - 1.3.6.1.4.1.232.5.2.4.1.1.23
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvPostErrs
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.24
    type: counter
    help: SCSI Physical Drive Power On Self Test (POST) Errors - 1.3.6.1.4.1.232.5.2.4.1.1.24
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvPostErrCode
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.25
    type: gauge
    help: SCSI Physical Drive Last POST Error Code - 1.3.6.1.4.1.232.5.2.4.1.1.25
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvCondition
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.26
    type: gauge
    help: SCSI Physical Drive Condition - 1.3.6.1.4.1.232.5.2.4.1.1.26
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqScsiPhyDrvFuncTest1
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.27
    type: gauge
    help: SCSI Physical Drive Functional Test 1 - 1.3.6.1.4.1.232.5.2.4.1.1.27
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvFuncTest2
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.28
    type: gauge
    help: SCSI Physical Drive Functional Test 2 - 1.3.6.1.4.1.232.5.2.4.1.1.28
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvStatsPreserved
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.29
    type: gauge
    help: SCSI Physical Drive Statistics Preservation Method - 1.3.6.1.4.1.232.5.2.4.1.1.29
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: inNVRAM
      3: onDisk
      4: noCPUSupport
      5: noFreeNVRAM
      6: noDrvSupport
      7: noSoftwareSupport
      8: statsNotSupported
  - name: cpqScsiPhyDrvSerialNum
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.30
    type: DisplayString
    help: SCSI Physical Drive Serial Number - 1.3.6.1.4.1.232.5.2.4.1.1.30
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvLocation
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.31
    type: gauge
    help: SCSI Physical Drive Location - 1.3.6.1.4.1.232.5.2.4.1.1.31
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: proliant
  - name: cpqScsiPhyDrvParent
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.32
    type: gauge
    help: SCSI Physical Drive Parent - 1.3.6.1.4.1.232.5.2.4.1.1.32
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvSectorSize
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.33
    type: gauge
    help: SCSI Physical Drive Sector Size in Bytes - 1.3.6.1.4.1.232.5.2.4.1.1.33
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvHotPlug
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.34
    type: gauge
    help: SCSI Physical Drive Hot Plug Support Status - 1.3.6.1.4.1.232.5.2.4.1.1.34
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: hotPlug
      3: nonHotPlug
  - name: cpqScsiPhyDrvPlacement
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.35
    type: gauge
    help: SCSI Physical Drive Placement - 1.3.6.1.4.1.232.5.2.4.1.1.35
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: internal
      3: external
  - name: cpqScsiPhyDrvPreFailMonitoring
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.36
    type: gauge
    help: SCSI Physical Drive Predictive Failure Monitoring - 1.3.6.1.4.1.232.5.2.4.1.1.36
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: notAvailable
      3: available
  - name: cpqScsiPhyDrvOsName
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.37
    type: DisplayString
    help: Physical Drive OS Name - 1.3.6.1.4.1.232.5.2.4.1.1.37
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
  - name: cpqScsiPhyDrvRotationalSpeed
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.38
    type: gauge
    help: SCSI Physical Drive Rotational Speed - 1.3.6.1.4.1.232.5.2.4.1.1.38
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: rpm7200
      3: rpm10K
      4: rpm15K
  - name: cpqScsiPhyDrvMemberLogDrv
    oid: 1.3.6.1.4.1.232.5.2.4.1.1.39
    type: gauge
    help: The Physical Drive is a Member of a Logical Drive - 1.3.6.1.4.1.232.5.2.4.1.1.39
    indexes:
    - labelname: cpqScsiPhyDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiPhyDrvBusIndex
      type: gauge
    - labelname: cpqScsiPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: member
      3: spare
      4: nonMember
  - name: cpqScsiTargetCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.1
    type: gauge
    help: SCSI Target Controller Index - 1.3.6.1.4.1.232.5.2.5.1.1.1
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetBusIndex
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.2
    type: gauge
    help: SCSI Target Bus Index - 1.3.6.1.4.1.232.5.2.5.1.1.2
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetScsiIdIndex
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.3
    type: gauge
    help: SCSI Target Device Index - 1.3.6.1.4.1.232.5.2.5.1.1.3
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetType
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.4
    type: gauge
    help: SCSI Device Type - 1.3.6.1.4.1.232.5.2.5.1.1.4
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
    enum_values:
      1: other
      2: disk
      3: tape
      4: printer
      5: processor
      6: wormDrive
      7: cd-rom
      8: scanner
      9: optical
      10: jukeBox
      11: commDev
  - name: cpqScsiTargetModel
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.5
    type: DisplayString
    help: SCSI Device Model - 1.3.6.1.4.1.232.5.2.5.1.1.5
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetFWRev
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.6
    type: DisplayString
    help: SCSI Device Firmware Revision - 1.3.6.1.4.1.232.5.2.5.1.1.6
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetVendor
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.7
    type: DisplayString
    help: SCSI Device Vendor - 1.3.6.1.4.1.232.5.2.5.1.1.7
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetParityErrs
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.8
    type: counter
    help: SCSI Device Bus Parity Errors - 1.3.6.1.4.1.232.5.2.5.1.1.8
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetPhaseErrs
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.9
    type: counter
    help: SCSI Device Bus Phase Errors - 1.3.6.1.4.1.232.5.2.5.1.1.9
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetSelectTimeouts
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.10
    type: counter
    help: SCSI Device Bus Select Time-outs - 1.3.6.1.4.1.232.5.2.5.1.1.10
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetMsgRejects
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.11
    type: counter
    help: SCSI Device Bus Message Rejects - 1.3.6.1.4.1.232.5.2.5.1.1.11
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetNegPeriod
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.12
    type: gauge
    help: SCSI Device Negotiated Period - 1.3.6.1.4.1.232.5.2.5.1.1.12
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetLocation
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.13
    type: gauge
    help: SCSI Device Location - 1.3.6.1.4.1.232.5.2.5.1.1.13
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
    enum_values:
      1: other
      2: proliant
  - name: cpqScsiTargetNegSpeed
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.14
    type: gauge
    help: SCSI Device Negotiated Speed - 1.3.6.1.4.1.232.5.2.5.1.1.14
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetPhysWidth
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.15
    type: gauge
    help: SCSI Device Data Bus Physical Width - 1.3.6.1.4.1.232.5.2.5.1.1.15
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
    enum_values:
      1: other
      2: narrow
      3: wide16
  - name: cpqScsiTargetNegWidth
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.16
    type: gauge
    help: SCSI Device Data Bus Negotiated Width - 1.3.6.1.4.1.232.5.2.5.1.1.16
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
  - name: cpqScsiTargetTypeExtended
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.17
    type: gauge
    help: SCSI Extended Device Type - 1.3.6.1.4.1.232.5.2.5.1.1.17
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
    enum_values:
      1: other
      2: pdcd
      3: removableDisk
      4: dltAutoloader
      5: cdJukebox
      6: cr3500
      7: autoloader
  - name: cpqScsiTargetCurrentSpeed
    oid: 1.3.6.1.4.1.232.5.2.5.1.1.18
    type: gauge
    help: SCSI Device Current Data Transfer Speed - 1.3.6.1.4.1.232.5.2.5.1.1.18
    indexes:
    - labelname: cpqScsiTargetCntlrIndex
      type: gauge
    - labelname: cpqScsiTargetBusIndex
      type: gauge
    - labelname: cpqScsiTargetScsiIdIndex
      type: gauge
    enum_values:
      1: other
      2: asynchronous
      3: fast
      4: ultra
      5: ultra2
      6: ultra3
      7: scsi1
      8: ultra4
  - name: cpqScsiCdDrvCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.6.1.1.1
    type: gauge
    help: SCSI CD-ROM Drive Controller Index - 1.3.6.1.4.1.232.5.2.6.1.1.1
    indexes:
    - labelname: cpqScsiCdDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiCdDrvBusIndex
      type: gauge
    - labelname: cpqScsiCdDrvScsiIdIndex
      type: gauge
    - labelname: cpqScsiCdDrvLunIndex
      type: gauge
  - name: cpqScsiCdDrvBusIndex
    oid: 1.3.6.1.4.1.232.5.2.6.1.1.2
    type: gauge
    help: SCSI CD-ROM Drive Bus Index - 1.3.6.1.4.1.232.5.2.6.1.1.2
    indexes:
    - labelname: cpqScsiCdDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiCdDrvBusIndex
      type: gauge
    - labelname: cpqScsiCdDrvScsiIdIndex
      type: gauge
    - labelname: cpqScsiCdDrvLunIndex
      type: gauge
  - name: cpqScsiCdDrvScsiIdIndex
    oid: 1.3.6.1.4.1.232.5.2.6.1.1.3
    type: gauge
    help: SCSI CD-ROM Drive Index - 1.3.6.1.4.1.232.5.2.6.1.1.3
    indexes:
    - labelname: cpqScsiCdDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiCdDrvBusIndex
      type: gauge
    - labelname: cpqScsiCdDrvScsiIdIndex
      type: gauge
    - labelname: cpqScsiCdDrvLunIndex
      type: gauge
  - name: cpqScsiCdDrvLunIndex
    oid: 1.3.6.1.4.1.232.5.2.6.1.1.4
    type: gauge
    help: SCSI CD-ROM Drive Logical Unit Index - 1.3.6.1.4.1.232.5.2.6.1.1.4
    indexes:
    - labelname: cpqScsiCdDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiCdDrvBusIndex
      type: gauge
    - labelname: cpqScsiCdDrvScsiIdIndex
      type: gauge
    - labelname: cpqScsiCdDrvLunIndex
      type: gauge
  - name: cpqScsiCdDrvModel
    oid: 1.3.6.1.4.1.232.5.2.6.1.1.5
    type: DisplayString
    help: SCSI CD Device Model - 1.3.6.1.4.1.232.5.2.6.1.1.5
    indexes:
    - labelname: cpqScsiCdDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiCdDrvBusIndex
      type: gauge
    - labelname: cpqScsiCdDrvScsiIdIndex
      type: gauge
    - labelname: cpqScsiCdDrvLunIndex
      type: gauge
  - name: cpqScsiCdDrvVendor
    oid: 1.3.6.1.4.1.232.5.2.6.1.1.6
    type: DisplayString
    help: SCSI CD Drive Vendor - 1.3.6.1.4.1.232.5.2.6.1.1.6
    indexes:
    - labelname: cpqScsiCdDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiCdDrvBusIndex
      type: gauge
    - labelname: cpqScsiCdDrvScsiIdIndex
      type: gauge
    - labelname: cpqScsiCdDrvLunIndex
      type: gauge
  - name: cpqScsiCdDrvFwRev
    oid: 1.3.6.1.4.1.232.5.2.6.1.1.7
    type: DisplayString
    help: SCSI CD-ROM Firmware Revision - 1.3.6.1.4.1.232.5.2.6.1.1.7
    indexes:
    - labelname: cpqScsiCdDrvCntlrIndex
      type: gauge
    - labelname: cpqScsiCdDrvBusIndex
      type: gauge
    - labelname: cpqScsiCdDrvScsiIdIndex
      type: gauge
    - labelname: cpqScsiCdDrvLunIndex
      type: gauge
  - name: cpqCdLibraryCntlrIndex
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.1
    type: gauge
    help: SCSI CD Library Controller Index - 1.3.6.1.4.1.232.5.2.6.2.1.1
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibraryBusIndex
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.2
    type: gauge
    help: SCSI CD Library Bus Index - 1.3.6.1.4.1.232.5.2.6.2.1.2
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibraryScsiIdIndex
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.3
    type: gauge
    help: SCSI CD Library Device Index - 1.3.6.1.4.1.232.5.2.6.2.1.3
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibraryLunIndex
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.4
    type: gauge
    help: SCSI CD Library Logical Unit Index - 1.3.6.1.4.1.232.5.2.6.2.1.4
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibraryCondition
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.5
    type: gauge
    help: CD Library Condition - 1.3.6.1.4.1.232.5.2.6.2.1.5
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqCdLibraryStatus
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.6
    type: gauge
    help: CD Library Status - 1.3.6.1.4.1.232.5.2.6.2.1.6
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: failed
      4: offline
  - name: cpqCdLibraryModel
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.7
    type: DisplayString
    help: SCSI CD Library Device Model - 1.3.6.1.4.1.232.5.2.6.2.1.7
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibraryVendor
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.8
    type: DisplayString
    help: SCSI CD Library Vendor - 1.3.6.1.4.1.232.5.2.6.2.1.8
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibrarySerialNumber
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.9
    type: DisplayString
    help: CD Library Serial Number - 1.3.6.1.4.1.232.5.2.6.2.1.9
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibraryDriveList
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.10
    type: OctetString
    help: CD Library Drive List This is a data structure containing the list of CD
      drive ids that are present in this library - 1.3.6.1.4.1.232.5.2.6.2.1.10
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibraryFwRev
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.11
    type: DisplayString
    help: SCSI CD Library Firmware Revision - 1.3.6.1.4.1.232.5.2.6.2.1.11
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqCdLibraryFwSubtype
    oid: 1.3.6.1.4.1.232.5.2.6.2.1.12
    type: gauge
    help: SCSI CD library Firmware Subtype - 1.3.6.1.4.1.232.5.2.6.2.1.12
    indexes:
    - labelname: cpqCdLibraryCntlrIndex
      type: gauge
    - labelname: cpqCdLibraryBusIndex
      type: gauge
    - labelname: cpqCdLibraryScsiIdIndex
      type: gauge
    - labelname: cpqCdLibraryLunIndex
      type: gauge
  - name: cpqScsiTrapPkts
    oid: 1.3.6.1.4.1.232.5.3.1
    type: counter
    help: The total number of trap packets issued by the SCSI enterprise since the
      instrument agent was loaded. - 1.3.6.1.4.1.232.5.3.1
  - name: cpqScsiTrapLogMaxSize
    oid: 1.3.6.1.4.1.232.5.3.2
    type: gauge
    help: The maximum number of entries that will currently be kept in the trap log
      - 1.3.6.1.4.1.232.5.3.2
  - name: cpqScsiTrapLogIndex
    oid: 1.3.6.1.4.1.232.5.3.3.1.1
    type: gauge
    help: The value of this object uniquely identifies this trapLogEntry at this time
      - 1.3.6.1.4.1.232.5.3.3.1.1
    indexes:
    - labelname: cpqScsiTrapLogIndex
      type: gauge
  - name: cpqScsiTrapType
    oid: 1.3.6.1.4.1.232.5.3.3.1.2
    type: gauge
    help: The type of the trap event that this entry describes - 1.3.6.1.4.1.232.5.3.3.1.2
    indexes:
    - labelname: cpqScsiTrapLogIndex
      type: gauge
    enum_values:
      1: cpqScsiCntlrStatusChange
      2: cpqScsiLogDrvStatusChange
      3: cpqScsiPhyDrvStatusChange
      5001: cpqScsi2CntlrStatusChange
      5002: cpqScsi2LogDrvStatusChange
      5003: cpqScsi2PhyDrvStatusChange
  - name: cpqScsiTrapTime
    oid: 1.3.6.1.4.1.232.5.3.3.1.3
    type: OctetString
    help: The time of the trap event that this entry describes - 1.3.6.1.4.1.232.5.3.3.1.3
    indexes:
    - labelname: cpqScsiTrapLogIndex
      type: gauge
  - name: cpqTapePhyDrvCntlrIndex
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.1
    type: gauge
    help: Tape Physical Drive Controller Index - 1.3.6.1.4.1.232.5.4.1.1.1.1
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvBusIndex
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.2
    type: gauge
    help: Tape Physical Drive Bus Index - 1.3.6.1.4.1.232.5.4.1.1.1.2
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvScsiIdIndex
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.3
    type: gauge
    help: Tape Physical Drive Index - 1.3.6.1.4.1.232.5.4.1.1.1.3
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvLunIndex
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.4
    type: gauge
    help: Tape Physical Drive Logical Unit Index - 1.3.6.1.4.1.232.5.4.1.1.1.4
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvType
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.5
    type: gauge
    help: Tape Device Type - 1.3.6.1.4.1.232.5.4.1.1.1.5
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
    enum_values:
      1: other
      2: cpqDat4-16
      3: cpqDatAuto
      4: cpqDat2-8
      5: cpqDlt10-20
      6: cpqDlt20-40
      7: cpqDlt15-30
      8: cpqDlt35-70
      9: cpqDat4-8
      10: cpqSlr4-8
      11: cpqDat12-24
      12: cpqDatAuto12-24
      13: cpqMlr16-32
      14: cpqAit35
      15: cpqAit50
      16: cpqDat20-40
      17: cpqDlt40-80
      18: cpqDatAuto20-40
      19: cpqSuperDlt1
      20: cpqAit35Lvd
      21: cpqCompaq
  - name: cpqTapePhyDrvCondition
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.6
    type: gauge
    help: Tape Physical Drive Status - 1.3.6.1.4.1.232.5.4.1.1.1.6
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqTapePhyDrvMagSize
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.7
    type: gauge
    help: Tape Physical Drive Magazine Size - 1.3.6.1.4.1.232.5.4.1.1.1.7
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvSerialNumber
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.8
    type: DisplayString
    help: Tape Physical Drive Serial Number - 1.3.6.1.4.1.232.5.4.1.1.1.8
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvCleanReq
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.9
    type: gauge
    help: Tape Physical Drive Cleaning Required Status - 1.3.6.1.4.1.232.5.4.1.1.1.9
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
    enum_values:
      1: other
      2: "true"
      3: "false"
  - name: cpqTapePhyDrvCleanTapeRepl
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.10
    type: gauge
    help: Tape Physical Drive Cleaning Tape Replacement Status - 1.3.6.1.4.1.232.5.4.1.1.1.10
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
    enum_values:
      1: other
      2: "true"
      3: "false"
  - name: cpqTapePhyDrvFwSubtype
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.11
    type: gauge
    help: Tape Physical Drive Firmware Subtype - 1.3.6.1.4.1.232.5.4.1.1.1.11
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvName
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.12
    type: DisplayString
    help: Tape Physical Drive Name - 1.3.6.1.4.1.232.5.4.1.1.1.12
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvCleanTapeCount
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.13
    type: gauge
    help: Tape Physical Drive Cleaning Tape Count - 1.3.6.1.4.1.232.5.4.1.1.1.13
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvFwRev
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.14
    type: DisplayString
    help: Tape Physical Drive Firmware Revision - 1.3.6.1.4.1.232.5.4.1.1.1.14
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvStatus
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.15
    type: gauge
    help: Tape Physical Drive Status - 1.3.6.1.4.1.232.5.4.1.1.1.15
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      4: failed
      5: offline
      6: missingWasOk
      7: missingWasFailed
      8: missingWasOffline
  - name: cpqTapePhyDrvHotPlug
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.16
    type: gauge
    help: Tape Physical Drive Hot Plug Support Status - 1.3.6.1.4.1.232.5.4.1.1.1.16
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
    enum_values:
      1: other
      2: hotPlug
      3: nonHotPlug
  - name: cpqTapePhyDrvPlacement
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.17
    type: gauge
    help: Tape Physical Drive Placement - 1.3.6.1.4.1.232.5.4.1.1.1.17
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
    enum_values:
      1: other
      2: internal
      3: external
  - name: cpqTapePhyDrvLibraryDrive
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.18
    type: gauge
    help: Tape Physical Drive Library Drive - 1.3.6.1.4.1.232.5.4.1.1.1.18
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
    enum_values:
      1: other
      2: "true"
      3: "false"
  - name: cpqTapePhyDrvLoaderName
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.19
    type: DisplayString
    help: Tape Autoloader Name - 1.3.6.1.4.1.232.5.4.1.1.1.19
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvLoaderFwRev
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.20
    type: DisplayString
    help: Tape Autoloader Firmware Revision - 1.3.6.1.4.1.232.5.4.1.1.1.20
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapePhyDrvLoaderSerialNum
    oid: 1.3.6.1.4.1.232.5.4.1.1.1.21
    type: DisplayString
    help: Tape Autoloader Serial Number - 1.3.6.1.4.1.232.5.4.1.1.1.21
    indexes:
    - labelname: cpqTapePhyDrvCntlrIndex
      type: gauge
    - labelname: cpqTapePhyDrvBusIndex
      type: gauge
    - labelname: cpqTapePhyDrvScsiIdIndex
      type: gauge
    - labelname: cpqTapePhyDrvLunIndex
      type: gauge
  - name: cpqTapeCountersCntlrIndex
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.1
    type: gauge
    help: SCSI Counters Controller Index - 1.3.6.1.4.1.232.5.4.2.1.1.1
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeCountersBusIndex
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.2
    type: gauge
    help: SCSI Counters Bus Index - 1.3.6.1.4.1.232.5.4.2.1.1.2
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeCountersScsiIdIndex
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.3
    type: gauge
    help: SCSI Counters Device Index - 1.3.6.1.4.1.232.5.4.2.1.1.3
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeCountersLunIndex
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.4
    type: gauge
    help: SCSI Counters Logical Unit Index - 1.3.6.1.4.1.232.5.4.2.1.1.4
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeCountersReWrites
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.5
    type: counter
    help: Tape Device Re-write count - 1.3.6.1.4.1.232.5.4.2.1.1.5
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeCountersReReads
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.6
    type: counter
    help: Tape Device Re-read count - 1.3.6.1.4.1.232.5.4.2.1.1.6
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeCountersTotalErrors
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.7
    type: counter
    help: Tape Device Total Errors - 1.3.6.1.4.1.232.5.4.2.1.1.7
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeCountersTotalUncorrectable
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.8
    type: counter
    help: Tape Device Total Uncorrectable Errors - 1.3.6.1.4.1.232.5.4.2.1.1.8
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeCountersTotalBytes
    oid: 1.3.6.1.4.1.232.5.4.2.1.1.9
    type: counter
    help: Tape Device Total Bytes - 1.3.6.1.4.1.232.5.4.2.1.1.9
    indexes:
    - labelname: cpqTapeCountersCntlrIndex
      type: gauge
    - labelname: cpqTapeCountersBusIndex
      type: gauge
    - labelname: cpqTapeCountersScsiIdIndex
      type: gauge
    - labelname: cpqTapeCountersLunIndex
      type: gauge
  - name: cpqTapeLibraryCntlrIndex
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.1
    type: gauge
    help: SCSI Library Controller Index - 1.3.6.1.4.1.232.5.4.3.1.1.1
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryBusIndex
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.2
    type: gauge
    help: SCSI Library Bus Index - 1.3.6.1.4.1.232.5.4.3.1.1.2
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryScsiIdIndex
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.3
    type: gauge
    help: SCSI Library Device Index - 1.3.6.1.4.1.232.5.4.3.1.1.3
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryLunIndex
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.4
    type: gauge
    help: SCSI Library Logical Unit Index - 1.3.6.1.4.1.232.5.4.3.1.1.4
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryCondition
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.5
    type: gauge
    help: Tape Library Status - 1.3.6.1.4.1.232.5.4.3.1.1.5
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqTapeLibraryStatus
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.6
    type: gauge
    help: Error code returned by the last library error. - 1.3.6.1.4.1.232.5.4.3.1.1.6
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryDoorStatus
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.7
    type: gauge
    help: Status of the library door - 1.3.6.1.4.1.232.5.4.3.1.1.7
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
    enum_values:
      1: other
      2: closed
      3: open
      4: notSupported
  - name: cpqTapeLibraryStatHours
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.8
    type: counter
    help: The number of hours of operation for the library. - 1.3.6.1.4.1.232.5.4.3.1.1.8
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryStatMoves
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.9
    type: counter
    help: The number of tape moves for the library loader arm. - 1.3.6.1.4.1.232.5.4.3.1.1.9
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryName
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.10
    type: DisplayString
    help: Tape Library Name. - 1.3.6.1.4.1.232.5.4.3.1.1.10
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibrarySerialNumber
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.11
    type: DisplayString
    help: Tape Library Serial Number - 1.3.6.1.4.1.232.5.4.3.1.1.11
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryDriveList
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.12
    type: OctetString
    help: Tape Library Drive List This is a data structure containing the list of
      tape drive ids that are present in this library - 1.3.6.1.4.1.232.5.4.3.1.1.12
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryState
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.13
    type: gauge
    help: Tape Library Status - 1.3.6.1.4.1.232.5.4.3.1.1.13
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
      5: offline
  - name: cpqTapeLibraryTemperature
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.14
    type: gauge
    help: Tape Library Temperature Status - 1.3.6.1.4.1.232.5.4.3.1.1.14
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: ok
      4: safeTempExceeded
      5: maxTempExceeded
  - name: cpqTapeLibraryRedundancy
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.15
    type: gauge
    help: Tape Library Redundancy Status - 1.3.6.1.4.1.232.5.4.3.1.1.15
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: capable
      4: notCapable
      5: active
  - name: cpqTapeLibraryHotSwap
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.16
    type: gauge
    help: Tape Library Hot Swap Status - 1.3.6.1.4.1.232.5.4.3.1.1.16
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: capable
      4: notCapable
  - name: cpqTapeLibraryFwRev
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.17
    type: DisplayString
    help: Tape Library Firmware Revision - 1.3.6.1.4.1.232.5.4.3.1.1.17
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqTapeLibraryTapeList
    oid: 1.3.6.1.4.1.232.5.4.3.1.1.18
    type: OctetString
    help: Tape Library Drive List This is a data structure containing the list of
      tape drive ids that are present in this library - 1.3.6.1.4.1.232.5.4.3.1.1.18
    indexes:
    - labelname: cpqTapeLibraryCntlrIndex
      type: gauge
    - labelname: cpqTapeLibraryBusIndex
      type: gauge
    - labelname: cpqTapeLibraryScsiIdIndex
      type: gauge
    - labelname: cpqTapeLibraryLunIndex
      type: gauge
  - name: cpqSasHbaIndex
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.1
    type: gauge
    help: SAS Host Bus Adapter Index - 1.3.6.1.4.1.232.5.5.1.1.1.1
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
  - name: cpqSasHbaHwLocation
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.2
    type: DisplayString
    help: SAS Host Bus Adapter Hardware Location - 1.3.6.1.4.1.232.5.5.1.1.1.2
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
  - name: cpqSasHbaModel
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.3
    type: gauge
    help: SAS Host Bus Adapter Model - 1.3.6.1.4.1.232.5.5.1.1.1.3
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
    enum_values:
      1: other
      2: generic
      3: sas8int
      4: sas4int
      5: sasSc44Ge
      6: sasSc40Ge
      7: sasSc08Ge
      8: sasSc08e
      9: sasH220i
      10: sasH221
      11: sasH210i
      12: sasH220
      13: sasH222
      14: sasP824ip
  - name: cpqSasHbaStatus
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.4
    type: gauge
    help: SAS Host Bus Adapter Status - 1.3.6.1.4.1.232.5.5.1.1.1.4
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: failed
  - name: cpqSasHbaCondition
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.5
    type: gauge
    help: SAS Host Bus Adapter Condition - 1.3.6.1.4.1.232.5.5.1.1.1.5
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqSasHbaOverallCondition
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.6
    type: gauge
    help: SAS Host Bus Adapter Overall Condition - 1.3.6.1.4.1.232.5.5.1.1.1.6
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqSasHbaSerialNumber
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.7
    type: DisplayString
    help: SAS Host Bus Adapter Serial Number - 1.3.6.1.4.1.232.5.5.1.1.1.7
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
  - name: cpqSasHbaFwVersion
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.8
    type: DisplayString
    help: SAS Host Bus Adapter Firmware Version - 1.3.6.1.4.1.232.5.5.1.1.1.8
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
  - name: cpqSasHbaBiosVersion
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.9
    type: DisplayString
    help: SAS Host Bus Adapter BIOS Version - 1.3.6.1.4.1.232.5.5.1.1.1.9
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
  - name: cpqSasHbaPciLocation
    oid: 1.3.6.1.4.1.232.5.5.1.1.1.10
    type: DisplayString
    help: SAS Host Bus Adapter PCI Location - 1.3.6.1.4.1.232.5.5.1.1.1.10
    indexes:
    - labelname: cpqSasHbaIndex
      type: gauge
  - name: cpqSasPhyDrvHbaIndex
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.1
    type: gauge
    help: SAS Physical Drive HBA Index - 1.3.6.1.4.1.232.5.5.2.1.1.1
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvIndex
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.2
    type: gauge
    help: SAS Physical Drive Index - 1.3.6.1.4.1.232.5.5.2.1.1.2
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvLocationString
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.3
    type: DisplayString
    help: SAS Physical Drive Location String - 1.3.6.1.4.1.232.5.5.2.1.1.3
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvModel
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.4
    type: DisplayString
    help: SAS Physical Drive Model - 1.3.6.1.4.1.232.5.5.2.1.1.4
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvStatus
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.5
    type: gauge
    help: SAS Physical Drive Status - 1.3.6.1.4.1.232.5.5.2.1.1.5
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: predictiveFailure
      4: offline
      5: failed
      6: missingWasOk
      7: missingWasPredictiveFailure
      8: missingWasOffline
      9: missingWasFailed
      10: ssdWearOut
      11: missingWasSSDWearOut
      12: notAuthenticated
      13: missingWasNotAuthenticated
  - name: cpqSasPhyDrvCondition
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.6
    type: gauge
    help: SAS Physical Drive Condition - 1.3.6.1.4.1.232.5.5.2.1.1.6
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqSasPhyDrvFWRev
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.7
    type: DisplayString
    help: SAS Physical Drive Firmware Revision - 1.3.6.1.4.1.232.5.5.2.1.1.7
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSize
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.8
    type: gauge
    help: SAS Physical Drive Size in MB - 1.3.6.1.4.1.232.5.5.2.1.1.8
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvUsedReallocs
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.9
    type: counter
    help: SAS Physical Drive Used Reallocation Sectors - 1.3.6.1.4.1.232.5.5.2.1.1.9
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSerialNumber
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.10
    type: DisplayString
    help: SAS Physical Drive Serial Number - 1.3.6.1.4.1.232.5.5.2.1.1.10
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvMemberLogDrv
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.11
    type: gauge
    help: The Physical Drive is a Member of a Logical Drive - 1.3.6.1.4.1.232.5.5.2.1.1.11
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: member
      3: spare
      4: nonMember
  - name: cpqSasPhyDrvRotationalSpeed
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.12
    type: gauge
    help: SAS Physical Drive Rotational Speed - 1.3.6.1.4.1.232.5.5.2.1.1.12
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: rpm7200
      3: rpm10K
      4: rpm15K
      5: rpmSsd
  - name: cpqSasPhyDrvOsName
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.13
    type: DisplayString
    help: SAS Physical Drive OS Name - 1.3.6.1.4.1.232.5.5.2.1.1.13
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvPlacement
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.14
    type: gauge
    help: SAS Physical Drive Placement - 1.3.6.1.4.1.232.5.5.2.1.1.14
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: internal
      3: external
  - name: cpqSasPhyDrvHotPlug
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.15
    type: gauge
    help: SAS Physical Drive Hot Plug Support Status - 1.3.6.1.4.1.232.5.5.2.1.1.15
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: hotPlug
      3: nonHotPlug
  - name: cpqSasPhyDrvType
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.16
    type: gauge
    help: SAS Physical Drive Type - 1.3.6.1.4.1.232.5.5.2.1.1.16
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: sas
      3: sata
  - name: cpqSasPhyDrvSasAddress
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.17
    type: DisplayString
    help: SAS Physical Drive SAS Address - 1.3.6.1.4.1.232.5.5.2.1.1.17
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvMediaType
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.18
    type: gauge
    help: SAS Physical Drive Media Type - 1.3.6.1.4.1.232.5.5.2.1.1.18
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: rotatingPlatters
      3: solidState
  - name: cpqSasPhyDrvSSDWearStatus
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.19
    type: gauge
    help: SAS Physical Drive Solid State Disk Wear Status - 1.3.6.1.4.1.232.5.5.2.1.1.19
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: fiftySixDayThreshold
      4: fivePercentThreshold
      5: twoPercentThreshold
      6: ssdWearOut
  - name: cpqSasPhyDrvPowerOnHours
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.20
    type: counter
    help: SAS Physical Drive Power On Hours - 1.3.6.1.4.1.232.5.5.2.1.1.20
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSSDPercntEndrnceUsed
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.21
    type: gauge
    help: SAS Physical Drive Solid State Percent Endurance Used - 1.3.6.1.4.1.232.5.5.2.1.1.21
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSSDEstTimeRemainingHours
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.22
    type: counter
    help: SAS Physical Drive Solid State Estimated Time Remaining In Hours - 1.3.6.1.4.1.232.5.5.2.1.1.22
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvAuthenticationStatus
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.23
    type: gauge
    help: SAS Physical Drive Authentication Status - 1.3.6.1.4.1.232.5.5.2.1.1.23
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
    enum_values:
      1: other
      2: notSupported
      3: authenticationFailed
      4: authenticationPassed
  - name: cpqSasPhyDrvSmartCarrierAppFWRev
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.24
    type: gauge
    help: SAS Physical Drive Smart Carrier Application Firmware Revision - 1.3.6.1.4.1.232.5.5.2.1.1.24
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSmartCarrierBootldrFWRev
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.25
    type: gauge
    help: SAS Physical Drive Smart Carrier Bootloader Firmware Revision - 1.3.6.1.4.1.232.5.5.2.1.1.25
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvCurrTemperature
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.26
    type: gauge
    help: SAS Physical Drive Current Operating Temperature degrees Celsius - 1.3.6.1.4.1.232.5.5.2.1.1.26
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvTemperatureThreshold
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.27
    type: gauge
    help: SAS Physical Drive Maximum Operating Temperature in degrees Celsius - 1.3.6.1.4.1.232.5.5.2.1.1.27
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSsBoxModel
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.28
    type: DisplayString
    help: SAS Physical Drive Box Model - 1.3.6.1.4.1.232.5.5.2.1.1.28
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSsBoxFwRev
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.29
    type: DisplayString
    help: SAS Physical Drive Box Firmware Revision - 1.3.6.1.4.1.232.5.5.2.1.1.29
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSsBoxVendor
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.30
    type: DisplayString
    help: SAS Physical Drive Box Vendor This is the SAS drive box`s vendor name -
      1.3.6.1.4.1.232.5.5.2.1.1.30
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasPhyDrvSsBoxSerialNumber
    oid: 1.3.6.1.4.1.232.5.5.2.1.1.31
    type: DisplayString
    help: SAS Physical Drive Box Serial Number - 1.3.6.1.4.1.232.5.5.2.1.1.31
    indexes:
    - labelname: cpqSasPhyDrvHbaIndex
      type: gauge
    - labelname: cpqSasPhyDrvIndex
      type: gauge
  - name: cpqSasLogDrvHbaIndex
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.1
    type: gauge
    help: SAS Logical Drive HBA Index - 1.3.6.1.4.1.232.5.5.3.1.1.1
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasLogDrvIndex
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.2
    type: gauge
    help: SAS Logical Drive Index - 1.3.6.1.4.1.232.5.5.3.1.1.2
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasLogDrvRaidLevel
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.3
    type: gauge
    help: SAS Logical Drive RAID Level - 1.3.6.1.4.1.232.5.5.3.1.1.3
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: raid0
      3: raid1
      4: raid0plus1
      5: raid5
      6: raid15
      7: volume
  - name: cpqSasLogDrvStatus
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.4
    type: gauge
    help: SAS Logical Drive Status - 1.3.6.1.4.1.232.5.5.3.1.1.4
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: rebuilding
      5: failed
      6: offline
  - name: cpqSasLogDrvCondition
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.5
    type: gauge
    help: SAS Logical Drive Condition - 1.3.6.1.4.1.232.5.5.3.1.1.5
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqSasLogDrvRebuildingDisk
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.6
    type: gauge
    help: SAS Logical Drive Rebuilding Disk - 1.3.6.1.4.1.232.5.5.3.1.1.6
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasLogDrvCapacity
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.7
    type: gauge
    help: SAS Logical Drive Size - 1.3.6.1.4.1.232.5.5.3.1.1.7
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasLogDrvStripeSize
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.8
    type: gauge
    help: SAS Logical Drive Stripe Size - 1.3.6.1.4.1.232.5.5.3.1.1.8
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasLogDrvPhyDrvIds
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.9
    type: OctetString
    help: SAS Logical Drive Physical Drive IDs - 1.3.6.1.4.1.232.5.5.3.1.1.9
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasLogDrvSpareIds
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.10
    type: OctetString
    help: SAS Logical Drive Spare Drive IDs - 1.3.6.1.4.1.232.5.5.3.1.1.10
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasLogDrvOsName
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.11
    type: DisplayString
    help: SAS Logical Drive OS Name - 1.3.6.1.4.1.232.5.5.3.1.1.11
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasLogDrvRebuildingPercent
    oid: 1.3.6.1.4.1.232.5.5.3.1.1.12
    type: gauge
    help: Logical Drive Percent Rebuild - 1.3.6.1.4.1.232.5.5.3.1.1.12
    indexes:
    - labelname: cpqSasLogDrvHbaIndex
      type: gauge
    - labelname: cpqSasLogDrvIndex
      type: gauge
  - name: cpqSasTapeDrvHbaIndex
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.1
    type: gauge
    help: SAS Tape Drive HBA Index - 1.3.6.1.4.1.232.5.5.4.1.1.1
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
  - name: cpqSasTapeDrvIndex
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.2
    type: gauge
    help: SAS Tape Drive Index - 1.3.6.1.4.1.232.5.5.4.1.1.2
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
  - name: cpqSasTapeDrvLocationString
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.3
    type: DisplayString
    help: SAS Tape Drive Location String - 1.3.6.1.4.1.232.5.5.4.1.1.3
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
  - name: cpqSasTapeDrvName
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.4
    type: DisplayString
    help: SAS Tape Drive Name - 1.3.6.1.4.1.232.5.5.4.1.1.4
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
  - name: cpqSasTapeDrvStatus
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.5
    type: gauge
    help: SAS Physical Drive Status - 1.3.6.1.4.1.232.5.5.4.1.1.5
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: offline
  - name: cpqSasTapeDrvCondition
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.6
    type: gauge
    help: SAS Tape Drive Condition - 1.3.6.1.4.1.232.5.5.4.1.1.6
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqSasTapeDrvFWRev
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.7
    type: DisplayString
    help: SAS Tape Drive Firmware Revision - 1.3.6.1.4.1.232.5.5.4.1.1.7
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
  - name: cpqSasTapeDrvSerialNumber
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.8
    type: DisplayString
    help: SAS Tape Drive Serial Number - 1.3.6.1.4.1.232.5.5.4.1.1.8
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
  - name: cpqSasTapeDrvSasAddress
    oid: 1.3.6.1.4.1.232.5.5.4.1.1.9
    type: DisplayString
    help: SAS Tape Drive SAS Address - 1.3.6.1.4.1.232.5.5.4.1.1.9
    indexes:
    - labelname: cpqSasTapeDrvHbaIndex
      type: gauge
    - labelname: cpqSasTapeDrvIndex
      type: gauge
  - name: cpqHeResMem2ModuleSize
    oid: 1.3.6.1.4.1.232.6.2.14.13.1.6
    type: gauge
    help: Module memory size in kilobytes - 1.3.6.1.4.1.232.6.2.14.13.1.6
    indexes:
    - labelname: cpqHeResMem2Module
      type: gauge
  - name: cpqHePowerMeterSupport
    oid: 1.3.6.1.4.1.232.6.2.15.1
    type: gauge
    help: This value specifies whether Power Meter is supported by this Server  -
      1.3.6.1.4.1.232.6.2.15.1
    enum_values:
      1: other
      2: supported
      3: unsupported
  - name: cpqHePowerMeterStatus
    oid: 1.3.6.1.4.1.232.6.2.15.2
    type: gauge
    help: This value specifies whether Power Meter reading is supported by this Server  -
      1.3.6.1.4.1.232.6.2.15.2
    enum_values:
      1: other
      2: present
      3: absent
  - name: cpqHePowerMeterCurrReading
    oid: 1.3.6.1.4.1.232.6.2.15.3
    type: gauge
    help: This is the current Power Meter reading in Watts - 1.3.6.1.4.1.232.6.2.15.3
  - name: cpqHePowerMeterPrevReading
    oid: 1.3.6.1.4.1.232.6.2.15.4
    type: gauge
    help: This is the previous Power Meter reading in Watts - 1.3.6.1.4.1.232.6.2.15.4
  - name: cpqHeHWBiosCondition
    oid: 1.3.6.1.4.1.232.6.2.16.1
    type: gauge
    help: This value indicates an error has been detected during Pre-OS Test (POST)
      or during initial hardware initialization - 1.3.6.1.4.1.232.6.2.16.1
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHeSysBackupBatteryCondition
    oid: 1.3.6.1.4.1.232.6.2.17.1
    type: gauge
    help: This value specifies the overall condition of the battery backup sub-system.
      - 1.3.6.1.4.1.232.6.2.17.1
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHeSysBatteryChassis
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.1
    type: gauge
    help: The system chassis number. - 1.3.6.1.4.1.232.6.2.17.2.1.1
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
  - name: cpqHeSysBatteryIndex
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.2
    type: gauge
    help: The battery index number within this chassis. - 1.3.6.1.4.1.232.6.2.17.2.1.2
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
  - name: cpqHeSysBatteryPresent
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.3
    type: gauge
    help: Indicates whether the backup battery is present in the chassis. - 1.3.6.1.4.1.232.6.2.17.2.1.3
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
    enum_values:
      1: other
      2: absent
      3: present
  - name: cpqHeSysBatteryCondition
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.4
    type: gauge
    help: The condition of the backup battery - 1.3.6.1.4.1.232.6.2.17.2.1.4
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHeSysBatteryStatus
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.5
    type: gauge
    help: The status of the battery. - 1.3.6.1.4.1.232.6.2.17.2.1.5
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
    enum_values:
      1: noError
      2: generalFailure
      3: shutdownHighResistance
      4: shutdownLowVoltage
      5: shutdownShortCircuit
      6: shutdownChargeTimeout
      7: shutdownOverTemperature
      8: shutdownDischargeMinVoltage
      9: shutdownDischargeCurrent
      10: shutdownLoadCountHigh
      11: shutdownEnablePin
      12: shutdownOverCurrent
      13: shutdownPermanentFailure
      14: shutdownBackupTimeExceeded
      15: predictiveFailure
  - name: cpqHeSysBatteryCapacityMaximum
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.6
    type: gauge
    help: The maximum capacity of the battery in watts. - 1.3.6.1.4.1.232.6.2.17.2.1.6
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
  - name: cpqHeSysBatteryProductName
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.7
    type: DisplayString
    help: The battery product name. - 1.3.6.1.4.1.232.6.2.17.2.1.7
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
  - name: cpqHeSysBatteryModel
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.8
    type: DisplayString
    help: The battery model name. - 1.3.6.1.4.1.232.6.2.17.2.1.8
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
  - name: cpqHeSysBatterySerialNumber
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.9
    type: DisplayString
    help: The battery serial number. - 1.3.6.1.4.1.232.6.2.17.2.1.9
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
  - name: cpqHeSysBatteryFirmwareRev
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.10
    type: DisplayString
    help: The battery firmware revision - 1.3.6.1.4.1.232.6.2.17.2.1.10
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
  - name: cpqHeSysBatterySparePartNum
    oid: 1.3.6.1.4.1.232.6.2.17.2.1.11
    type: DisplayString
    help: The battery part number or spare part number. - 1.3.6.1.4.1.232.6.2.17.2.1.11
    indexes:
    - labelname: cpqHeSysBatteryChassis
      type: gauge
    - labelname: cpqHeSysBatteryIndex
      type: gauge
  - name: cpqHeFltTolFanChassis
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.1
    type: gauge
    help: The System Chassis number. - 1.3.6.1.4.1.232.6.2.6.7.1.1
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
  - name: cpqHeFltTolFanIndex
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.2
    type: gauge
    help: A number that uniquely specifies this fan description. - 1.3.6.1.4.1.232.6.2.6.7.1.2
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
  - name: cpqHeFltTolFanLocale
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.3
    type: gauge
    help: This specifies the location of the fan in the system. - 1.3.6.1.4.1.232.6.2.6.7.1.3
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: system
      4: systemBoard
      5: ioBoard
      6: cpu
      7: memory
      8: storage
      9: removableMedia
      10: powerSupply
      11: ambient
      12: chassis
      13: bridgeCard
      14: managementBoard
      15: backplane
      16: networkSlot
      17: bladeSlot
      18: virtual
  - name: cpqHeFltTolFanPresent
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.4
    type: gauge
    help: This specifies if the fan described is present in the system. - 1.3.6.1.4.1.232.6.2.6.7.1.4
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
    enum_values:
      1: other
      2: absent
      3: present
  - name: cpqHeFltTolFanType
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.5
    type: gauge
    help: This specifies the type of fan - 1.3.6.1.4.1.232.6.2.6.7.1.5
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
    enum_values:
      1: other
      2: tachOutput
      3: spinDetect
  - name: cpqHeFltTolFanSpeed
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.6
    type: gauge
    help: This specifies the speed of the fan - 1.3.6.1.4.1.232.6.2.6.7.1.6
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
    enum_values:
      1: other
      2: normal
      3: high
  - name: cpqHeFltTolFanRedundant
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.7
    type: gauge
    help: This specifies if the fan is in a redundant configuration. - 1.3.6.1.4.1.232.6.2.6.7.1.7
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
    enum_values:
      1: other
      2: notRedundant
      3: redundant
  - name: cpqHeFltTolFanRedundantPartner
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.8
    type: gauge
    help: This specifies the index of the redundant partner - 1.3.6.1.4.1.232.6.2.6.7.1.8
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
  - name: cpqHeFltTolFanCondition
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.9
    type: gauge
    help: The condition of the fan - 1.3.6.1.4.1.232.6.2.6.7.1.9
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHeFltTolFanHotPlug
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.10
    type: gauge
    help: This indicates if the fan is capable of being removed and/or inserted while
      the system is in an operational state - 1.3.6.1.4.1.232.6.2.6.7.1.10
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
    enum_values:
      1: other
      2: nonHotPluggable
      3: hotPluggable
  - name: cpqHeFltTolFanHwLocation
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.11
    type: DisplayString
    help: A text description of the hardware location, on complex multi SBB hardware
      only, for the fan - 1.3.6.1.4.1.232.6.2.6.7.1.11
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
  - name: cpqHeFltTolFanCurrentSpeed
    oid: 1.3.6.1.4.1.232.6.2.6.7.1.12
    type: gauge
    help: The current speed of a fan in rpm - revolutions per minute. - 1.3.6.1.4.1.232.6.2.6.7.1.12
    indexes:
    - labelname: cpqHeFltTolFanChassis
      type: gauge
    - labelname: cpqHeFltTolFanIndex
      type: gauge
  - name: cpqHeTemperatureChassis
    oid: 1.3.6.1.4.1.232.6.2.6.8.1.1
    type: gauge
    help: The System Chassis number. - 1.3.6.1.4.1.232.6.2.6.8.1.1
    indexes:
    - labelname: cpqHeTemperatureChassis
      type: gauge
    - labelname: cpqHeTemperatureIndex
      type: gauge
  - name: cpqHeTemperatureIndex
    oid: 1.3.6.1.4.1.232.6.2.6.8.1.2
    type: gauge
    help: A number that uniquely specifies this temperature sensor description. -
      1.3.6.1.4.1.232.6.2.6.8.1.2
    indexes:
    - labelname: cpqHeTemperatureChassis
      type: gauge
    - labelname: cpqHeTemperatureIndex
      type: gauge
  - name: cpqHeTemperatureLocale
    oid: 1.3.6.1.4.1.232.6.2.6.8.1.3
    type: gauge
    help: This specifies the location of the temperature sensor present in the system.
      - 1.3.6.1.4.1.232.6.2.6.8.1.3
    indexes:
    - labelname: cpqHeTemperatureChassis
      type: gauge
    - labelname: cpqHeTemperatureIndex
      type: gauge
    enum_values:
      1: other
      2: unknown
      3: system
      4: systemBoard
      5: ioBoard
      6: cpu
      7: memory
      8: storage
      9: removableMedia
      10: powerSupply
      11: ambient
      12: chassis
      13: bridgeCard
  - name: cpqHeTemperatureCelsius
    oid: 1.3.6.1.4.1.232.6.2.6.8.1.4
    type: gauge
    help: This is the current temperature sensor reading in degrees celsius - 1.3.6.1.4.1.232.6.2.6.8.1.4
    indexes:
    - labelname: cpqHeTemperatureChassis
      type: gauge
    - labelname: cpqHeTemperatureIndex
      type: gauge
  - name: cpqHeTemperatureThreshold
    oid: 1.3.6.1.4.1.232.6.2.6.8.1.5
    type: gauge
    help: This is the shutdown threshold temperature sensor setting in degrees celsius
      - 1.3.6.1.4.1.232.6.2.6.8.1.5
    indexes:
    - labelname: cpqHeTemperatureChassis
      type: gauge
    - labelname: cpqHeTemperatureIndex
      type: gauge
  - name: cpqHeTemperatureCondition
    oid: 1.3.6.1.4.1.232.6.2.6.8.1.6
    type: gauge
    help: The Temperature sensor condition - 1.3.6.1.4.1.232.6.2.6.8.1.6
    indexes:
    - labelname: cpqHeTemperatureChassis
      type: gauge
    - labelname: cpqHeTemperatureIndex
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHeTemperatureThresholdType
    oid: 1.3.6.1.4.1.232.6.2.6.8.1.7
    type: gauge
    help: This specifies the type of this instance of temperature sensor - 1.3.6.1.4.1.232.6.2.6.8.1.7
    indexes:
    - labelname: cpqHeTemperatureChassis
      type: gauge
    - labelname: cpqHeTemperatureIndex
      type: gauge
    enum_values:
      1: other
      5: blowout
      9: caution
      15: critical
      16: noreaction
  - name: cpqHeTemperatureHwLocation
    oid: 1.3.6.1.4.1.232.6.2.6.8.1.8
    type: DisplayString
    help: A text description of the hardware location, on complex multi SBB hardware
      only, for the temperature sensor - 1.3.6.1.4.1.232.6.2.6.8.1.8
    indexes:
    - labelname: cpqHeTemperatureChassis
      type: gauge
    - labelname: cpqHeTemperatureIndex
      type: gauge
  - name: cpqHeFltTolPwrSupplyCondition
    oid: 1.3.6.1.4.1.232.6.2.9.1
    type: gauge
    help: This value specifies the overall condition of the fault tolerant power supply
      sub-system. - 1.3.6.1.4.1.232.6.2.9.1
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHeFltTolPwrSupplyStatus
    oid: 1.3.6.1.4.1.232.6.2.9.2
    type: gauge
    help: This value specifies the status of the fault tolerant power supply. - 1.3.6.1.4.1.232.6.2.9.2
    enum_values:
      1: other
      2: notSupported
      3: notInstalled
      4: installed
  - name: cpqHeFltTolPowerSupplyChassis
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.1
    type: gauge
    help: The system chassis number. - 1.3.6.1.4.1.232.6.2.9.3.1.1
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyBay
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.2
    type: gauge
    help: The bay number to index within this chassis. - 1.3.6.1.4.1.232.6.2.9.3.1.2
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyPresent
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.3
    type: gauge
    help: Indicates whether the power supply is present in the chassis. - 1.3.6.1.4.1.232.6.2.9.3.1.3
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
    enum_values:
      1: other
      2: absent
      3: present
  - name: cpqHeFltTolPowerSupplyCondition
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.4
    type: gauge
    help: The condition of the power supply - 1.3.6.1.4.1.232.6.2.9.3.1.4
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
    enum_values:
      1: other
      2: ok
      3: degraded
      4: failed
  - name: cpqHeFltTolPowerSupplyStatus
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.5
    type: gauge
    help: The status of the power supply. - 1.3.6.1.4.1.232.6.2.9.3.1.5
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
    enum_values:
      1: noError
      2: generalFailure
      3: bistFailure
      4: fanFailure
      5: tempFailure
      6: interlockOpen
      7: epromFailed
      8: vrefFailed
      9: dacFailed
      10: ramTestFailed
      11: voltageChannelFailed
      12: orringdiodeFailed
      13: brownOut
      14: giveupOnStartup
      15: nvramInvalid
      16: calibrationTableInvalid
      17: noPowerInput
  - name: cpqHeFltTolPowerSupplyMainVoltage
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.6
    type: gauge
    help: The input main voltage of the power supply in volts. - 1.3.6.1.4.1.232.6.2.9.3.1.6
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyCapacityUsed
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.7
    type: gauge
    help: The currently used capacity of the power supply in watts. - 1.3.6.1.4.1.232.6.2.9.3.1.7
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyCapacityMaximum
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.8
    type: gauge
    help: The maximum capacity of the power supply in watts. - 1.3.6.1.4.1.232.6.2.9.3.1.8
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyRedundant
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.9
    type: gauge
    help: The redundancy state of the power supply - 1.3.6.1.4.1.232.6.2.9.3.1.9
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
    enum_values:
      1: other
      2: notRedundant
      3: redundant
  - name: cpqHeFltTolPowerSupplyModel
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.10
    type: DisplayString
    help: The power supply model name. - 1.3.6.1.4.1.232.6.2.9.3.1.10
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplySerialNumber
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.11
    type: DisplayString
    help: The power supply serial number. - 1.3.6.1.4.1.232.6.2.9.3.1.11
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyAutoRev
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.12
    type: OctetString
    help: The power supply auto revision number. - 1.3.6.1.4.1.232.6.2.9.3.1.12
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyHotPlug
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.13
    type: gauge
    help: This indicates if the power supply is capable of being removed and/or inserted
      while the system is in an operational state - 1.3.6.1.4.1.232.6.2.9.3.1.13
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
    enum_values:
      1: other
      2: nonHotPluggable
      3: hotPluggable
  - name: cpqHeFltTolPowerSupplyFirmwareRev
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.14
    type: DisplayString
    help: The power supply firmware revision - 1.3.6.1.4.1.232.6.2.9.3.1.14
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyHwLocation
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.15
    type: DisplayString
    help: A text description of the hardware location, on complex multi SBB hardware
      only, for the power supply - 1.3.6.1.4.1.232.6.2.9.3.1.15
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplySparePartNum
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.16
    type: DisplayString
    help: The power supply part number or spare part number. - 1.3.6.1.4.1.232.6.2.9.3.1.16
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyRedundantPartner
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.17
    type: gauge
    help: This specifies the index of the redundant partner - 1.3.6.1.4.1.232.6.2.9.3.1.17
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
  - name: cpqHeFltTolPowerSupplyErrorCondition
    oid: 1.3.6.1.4.1.232.6.2.9.3.1.18
    type: gauge
    help: The Error condition of the power supply. - 1.3.6.1.4.1.232.6.2.9.3.1.18
    indexes:
    - labelname: cpqHeFltTolPowerSupplyChassis
      type: gauge
    - labelname: cpqHeFltTolPowerSupplyBay
      type: gauge
    enum_values:
      1: noError
      2: generalFailure
      3: overvoltage
      4: overcurrent
      5: overtemperature
      6: powerinputloss
      7: fanfailure
      8: vinhighwarning
      9: vinlowwarning
      10: vouthighwarning
      11: voutlowwarning
      12: inlettemphighwarning
      13: iinternaltemphighwarning
      14: vauxhighwarning
      15: vauxlowwarning
      16: powersupplymismatch
      17: goodinstandby
  - name: cpqSm2CntlrRomDate
    oid: 1.3.6.1.4.1.232.9.2.2.1
    type: DisplayString
    help: Remote Insight/ Integrated Lights-Out ROM Date - 1.3.6.1.4.1.232.9.2.2.1
  - name: cpqSm2CntlrRomRevision
    oid: 1.3.6.1.4.1.232.9.2.2.2
    type: DisplayString
    help: Remote Insight/ Integrated Lights-Out ROM Revision - 1.3.6.1.4.1.232.9.2.2.2
  - name: cpqSm2CntlrVideoStatus
    oid: 1.3.6.1.4.1.232.9.2.2.3
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Video Hardware Status - 1.3.6.1.4.1.232.9.2.2.3
    enum_values:
      1: other
      2: enabled
      3: disabled
  - name: cpqSm2CntlrBatteryEnabled
    oid: 1.3.6.1.4.1.232.9.2.2.4
    type: gauge
    help: Remote Insight Battery Enabled - 1.3.6.1.4.1.232.9.2.2.4
    enum_values:
      1: other
      2: enabled
      3: disabled
      4: noBattery
  - name: cpqSm2CntlrBatteryStatus
    oid: 1.3.6.1.4.1.232.9.2.2.5
    type: gauge
    help: Remote Insight Battery Status - 1.3.6.1.4.1.232.9.2.2.5
    enum_values:
      1: other
      2: batteryOk
      3: batteryFailed
      4: batteryDisconnected
  - name: cpqSm2CntlrBatteryPercentCharged
    oid: 1.3.6.1.4.1.232.9.2.2.6
    type: gauge
    help: Remote Insight Battery Percent Charged - 1.3.6.1.4.1.232.9.2.2.6
  - name: cpqSm2CntlrAlertStatus
    oid: 1.3.6.1.4.1.232.9.2.2.7
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Alerting Status - 1.3.6.1.4.1.232.9.2.2.7
    enum_values:
      1: other
      2: enabled
      3: disabled
  - name: cpqSm2CntlrPendingAlerts
    oid: 1.3.6.1.4.1.232.9.2.2.8
    type: gauge
    help: Pending Remote Insight/ Integrated Lights-Out alerts - 1.3.6.1.4.1.232.9.2.2.8
    enum_values:
      1: other
      2: noAlertsPending
      3: alertsPending
      4: clearPendingAlerts
  - name: cpqSm2CntlrSelfTestErrors
    oid: 1.3.6.1.4.1.232.9.2.2.9
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Self Test Errors - 1.3.6.1.4.1.232.9.2.2.9
  - name: cpqSm2CntlrAgentLocation
    oid: 1.3.6.1.4.1.232.9.2.2.10
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Agent Location - 1.3.6.1.4.1.232.9.2.2.10
    enum_values:
      1: hostOsAgent
      2: firmwareAgent
      3: remoteInsightPciFirmwareAgent
      4: enclosureFirmwareAgent
  - name: cpqSm2CntlrLastDataUpdate
    oid: 1.3.6.1.4.1.232.9.2.2.11
    type: OctetString
    help: The date and time that the Remote Insight/ Integrated Lights-Out offline
      data was last updated - 1.3.6.1.4.1.232.9.2.2.11
  - name: cpqSm2CntlrDataStatus
    oid: 1.3.6.1.4.1.232.9.2.2.12
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Host OS Data Status - 1.3.6.1.4.1.232.9.2.2.12
    enum_values:
      1: other
      2: noData
      3: onlineData
      4: offlineData
  - name: cpqSm2CntlrColdReboot
    oid: 1.3.6.1.4.1.232.9.2.2.13
    type: gauge
    help: 'Remote Insight/ Integrated Lights-Out Server Cold Reboot The following
      values are defined: notAvailable(1) Cold reboot of the system is not available
      - 1.3.6.1.4.1.232.9.2.2.13'
    enum_values:
      1: notAvailable
      2: available
      3: doColdReboot
  - name: cpqSm2CntlrBadLoginAttemptsThresh
    oid: 1.3.6.1.4.1.232.9.2.2.14
    type: gauge
    help: Maximum Unauthorized Login Attempts Threshold - 1.3.6.1.4.1.232.9.2.2.14
  - name: cpqSm2CntlrBoardSerialNumber
    oid: 1.3.6.1.4.1.232.9.2.2.15
    type: DisplayString
    help: Remote Insight/ Integrated Lights-Out Serial Number - 1.3.6.1.4.1.232.9.2.2.15
  - name: cpqSm2CntlrRemoteSessionStatus
    oid: 1.3.6.1.4.1.232.9.2.2.16
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Session Status - 1.3.6.1.4.1.232.9.2.2.16
    enum_values:
      1: other
      2: active
      3: inactive
  - name: cpqSm2CntlrInterfaceStatus
    oid: 1.3.6.1.4.1.232.9.2.2.17
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Interface Status - 1.3.6.1.4.1.232.9.2.2.17
    enum_values:
      1: other
      2: ok
      3: notResponding
  - name: cpqSm2CntlrSystemId
    oid: 1.3.6.1.4.1.232.9.2.2.18
    type: DisplayString
    help: Remote Insight/ Integrated Lights-Out System ID - 1.3.6.1.4.1.232.9.2.2.18
  - name: cpqSm2CntlrKeyboardCableStatus
    oid: 1.3.6.1.4.1.232.9.2.2.19
    type: gauge
    help: Remote Insight Keyboard Cable Status - 1.3.6.1.4.1.232.9.2.2.19
    enum_values:
      1: other
      2: connected
      3: disconnected
  - name: cpqSm2ServerIpAddress
    oid: 1.3.6.1.4.1.232.9.2.2.20
    type: InetAddressIPv4
    help: The IP address for this servers connection to the Remote Insight/ Integrated
      Lights-Out - 1.3.6.1.4.1.232.9.2.2.20
  - name: cpqSm2CntlrModel
    oid: 1.3.6.1.4.1.232.9.2.2.21
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Model - 1.3.6.1.4.1.232.9.2.2.21
    enum_values:
      1: other
      2: eisaRemoteInsightBoard
      3: pciRemoteInsightBoard
      4: pciLightsOutRemoteInsightBoard
      5: pciIntegratedLightsOutRemoteInsight
      6: pciLightsOutRemoteInsightBoardII
      7: pciIntegratedLightsOutRemoteInsight2
      8: pciLightsOut100series
      9: pciIntegratedLightsOutRemoteInsight3
      10: pciIntegratedLightsOutRemoteInsight4
      11: pciIntegratedLightsOutRemoteInsight5
  - name: cpqSm2CntlrSelfTestErrorMask
    oid: 1.3.6.1.4.1.232.9.2.2.22
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Self Test Error Mask - 1.3.6.1.4.1.232.9.2.2.22
  - name: cpqSm2CntlrMouseCableStatus
    oid: 1.3.6.1.4.1.232.9.2.2.23
    type: gauge
    help: Remote Insight Mouse Cable Status - 1.3.6.1.4.1.232.9.2.2.23
    enum_values:
      1: other
      2: connected
      3: disconnected
  - name: cpqSm2CntlrVirtualPowerCableStatus
    oid: 1.3.6.1.4.1.232.9.2.2.24
    type: gauge
    help: Remote Insight Virtual Power Cable Status - 1.3.6.1.4.1.232.9.2.2.24
    enum_values:
      1: other
      2: connected
      3: disconnected
      4: notApplicable
  - name: cpqSm2CntlrExternalPowerCableStatus
    oid: 1.3.6.1.4.1.232.9.2.2.25
    type: gauge
    help: Remote Insight External Power Cable Status - 1.3.6.1.4.1.232.9.2.2.25
    enum_values:
      1: other
      2: externallyConnected
      3: disconnected
      4: internallyConnected
      5: externallyAndInternallyConnected
      6: notApplicable
  - name: cpqSm2CntlrHostGUID
    oid: 1.3.6.1.4.1.232.9.2.2.26
    type: OctetString
    help: The globally unique identifier of this server - 1.3.6.1.4.1.232.9.2.2.26
  - name: cpqSm2CntlriLOSecurityOverrideSwitchState
    oid: 1.3.6.1.4.1.232.9.2.2.27
    type: gauge
    help: Integrated Lights-Out Security Override Switch State - 1.3.6.1.4.1.232.9.2.2.27
    enum_values:
      1: notSupported
      2: set
      3: notSet
  - name: cpqSm2CntlrHardwareVer
    oid: 1.3.6.1.4.1.232.9.2.2.28
    type: gauge
    help: Hardware Version of Remote Insight/ Integrated Lights-Out. - 1.3.6.1.4.1.232.9.2.2.28
  - name: cpqSm2CntlrAction
    oid: 1.3.6.1.4.1.232.9.2.2.29
    type: gauge
    help: Remote Insight/ Integrated Lights-Out Action Flags - 1.3.6.1.4.1.232.9.2.2.29
  - name: cpqSm2CntlrLicenseActive
    oid: 1.3.6.1.4.1.232.9.2.2.30
    type: gauge
    help: Remote Insight License State - 1.3.6.1.4.1.232.9.2.2.30
    enum_values:
      1: none
      2: iloAdvanced
      3: iloLight
      4: iloAdvancedBlade
      5: iloStandard
      6: iloEssentials
      7: iloScaleOut
      8: iloAdvancedPremiumSecurity
  - name: cpqSm2CntlrLicenseKey
    oid: 1.3.6.1.4.1.232.9.2.2.31
    type: DisplayString
    help: iLO Active ASCII License key string - 1.3.6.1.4.1.232.9.2.2.31
  - name: cpqSm2CntlrServerPowerState
    oid: 1.3.6.1.4.1.232.9.2.2.32
    type: gauge
    help: The current power state for the server - 1.3.6.1.4.1.232.9.2.2.32
    enum_values:
      1: unknown
      2: poweredOff
      3: poweredOn
      4: insufficientPowerOrPowerOnDenied
  - name: cpqSm2CntlrSysAutoShutdownCause
    oid: 1.3.6.1.4.1.232.9.2.2.33
    type: gauge
    help: Indicate the reason for triggering system auto shutdown or cancelling auto
      shutdown. - 1.3.6.1.4.1.232.9.2.2.33
    enum_values:
      1: fanFailure
      2: overheatCondition
      3: vrmFailure
      4: powerSupplyFailure
      5: systemRunningOnBatteryBackupUnit
      129: aborted
      130: fanFailureAborted
      131: overheatAborted
      132: vrmFailureAborted
      133: softPowerDown
      134: softwareAutomaticServerRecovery
      135: powerSupplyFailureAborted
  - name: cpqSm2CntlrSecurityState
    oid: 1.3.6.1.4.1.232.9.2.2.34
    type: gauge
    help: Indicate security state - 1.3.6.1.4.1.232.9.2.2.34
    enum_values:
      1: factory
      2: wipe
      3: production
      4: highSecurity
      5: fips
      6: cnsa
  - name: cpqSm2WDTimerType
    oid: 1.3.6.1.4.1.232.9.2.2.35
    type: gauge
    help: Indicate the watchdog timer type. - 1.3.6.1.4.1.232.9.2.2.35
    enum_values:
      1: unknown
      2: ipmi
  - name: cpqSm2WDTimerTimeoutDetails
    oid: 1.3.6.1.4.1.232.9.2.2.36
    type: DisplayString
    help: Indicate the watchdog timer timeout action and timer details. - 1.3.6.1.4.1.232.9.2.2.36
  - name: cpqSm2CntlrOverallSecStatus
    oid: 1.3.6.1.4.1.232.9.2.2.37
    type: gauge
    help: The field indicates the overall security status. - 1.3.6.1.4.1.232.9.2.2.37
    enum_values:
      1: Ok
      2: Risk
      3: Ignored
  version: 2
  timeout: 30s
  auth:
    community: public
EOF

systemctl daemon-reload
systemctl enable --now snmp-exporter
