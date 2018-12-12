import AWS from 'aws-sdk'
import Debug from 'debug'

const debug = Debug('op:route-53')

/**
 *
 * @param HostedZoneId
 * @param domainName
 * @param greenInfo {aliasDnsName, aliasZoneId, weight}
 * @param blueInfo {aliasDnsName, aliasZoneId, weight}
 * @returns {Promise<void>}
 */
export const upsertRoute53Records = async (HostedZoneId, domainName, blueInfo, greenInfo) => {
  const params = {
    ChangeBatch: {
      Changes: [
        {
          Action: 'UPSERT',
          ResourceRecordSet: {
            AliasTarget: {
              DNSName: greenInfo.aliasDnsName,
              EvaluateTargetHealth: true,
              HostedZoneId: greenInfo.aliasZoneId
            },
            Name: domainName,
            SetIdentifier: 'Green',
            Type: 'A',
            Weight: greenInfo.weight
          }
        }, {
          Action: 'UPSERT',
          ResourceRecordSet: {
            AliasTarget: {
              DNSName: blueInfo.aliasDnsName,
              EvaluateTargetHealth: true,
              HostedZoneId: blueInfo.aliasZoneId
            },
            Name: domainName,
            SetIdentifier: 'Blue',
            Type: 'A',
            Weight: blueInfo.weight
          }
        }
      ],
      Comment: `ALB load balancers for ${domainName}`
    },
    HostedZoneId
  }

  debug('route53 params', JSON.stringify(params, null, 2))

  const route53 = new AWS.Route53()
  return route53.changeResourceRecordSets(params).promise()
}
