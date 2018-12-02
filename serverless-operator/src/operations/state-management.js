import Joi from 'joi'
import dynogels from "dynogels"

const BgState = dynogels.define('bgstate', {
  hashKey : 'key',

  timestamps : true,

  schema : {
    value : Joi.string()
  },

  validation: {
    allowUnknown: true
  }
})

const NameKeyPrefixColumn = '$$name-key-prefix'
const loadBalancerZoneIdKey = dnsName => `${dnsName}/lb/zoneId`
const route53WeightKey = dnsName => `${dnsName}/route53/weight`
const simpleServiceDockerTagKey = dnsName => `${dnsName}/simpleservice/dockertag`

const getValue = key => new Promise((resolve, reject) => {
  BgState.get(key, (err, keyValue) => {
    if (err) return reject(err)
    if (keyValue) {
      return resolve(JSON.parse(keyValue.get('value')))
    }
    return resolve(keyValue);
  })
})

const updateValue = key => value => new Promise((resolve, reject) => {
  const ddbValue = JSON.stringify(value)
  return BgState.update({
    key,
    value: ddbValue
  }, (err, keyValue) => {
    if (err) return reject(err)
    return resolve(keyValue)
  })
})

export const getAllDnsNameKeyPrefix = () => getValue(NameKeyPrefixColumn)
export const updateDnsNameKeyPrefix = updateValue(NameKeyPrefixColumn)

export const getLoadBalancerZoneId = dnsName => getValue(loadBalancerZoneIdKey(dnsName))
export const updateLoadBalancerZoneId = dnsName => updateValue(loadBalancerZoneIdKey(dnsName))

export const getDnsNamesWeight = dnsName => getValue(route53WeightKey(dnsName))
export const updateDnsNamesWeight = dnsName => updateValue(route53WeightKey(dnsName))

export const getSimpleServiceDockerTag = dnsName => getValue(simpleServiceDockerTagKey(dnsName))
export const updateSimpleServiceDockerTag = dnsName => updateValue(simpleServiceDockerTagKey(dnsName))
